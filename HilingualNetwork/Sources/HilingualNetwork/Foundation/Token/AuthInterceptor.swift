//
//  AuthInterceptor.swift
//  HilingualNetwork
//
//  Created by 성현주 on 7/15/25.
//

import Foundation
import Moya
import Alamofire

public final class AuthInterceptor: RequestInterceptor {
    private let lock = NSLock()
    private var isRefreshing = false
    private var requestsToRetry: [(RetryResult) -> Void] = []

    private let refreshProvider = MoyaProvider<AuthAPI>(plugins: [])

    public init() {}

    // ✅ 1. 요청에 accessToken 추가
    public func adapt(_ urlRequest: URLRequest,
                      for session: Session,
                      completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        let token = UserDefaultHandler.accessToken

        if !token.isEmpty {
            print("[AuthInterceptor] ✅ 요청에 액세스 토큰 추가됨")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            print("[AuthInterceptor] ⚠️ 저장된 액세스 토큰이 없습니다")
        }
        completion(.success(request))
    }

    // ✅ 2. 401 오류 발생 시 토큰 재발급 시도
    public func retry(_ request: Request,
                      for session: Session,
                      dueTo error: Error,
                      completion: @escaping (RetryResult) -> Void) {
        guard
            let response = request.task?.response as? HTTPURLResponse,
            response.statusCode == 401
        else {
            print("[AuthInterceptor] ❌ 401 오류가 아니므로 재시도하지 않음")
            completion(.doNotRetry)
            return
        }

        print("[AuthInterceptor] 🚨 401 오류 발생 - 토큰 재발급 시도 예정")

        lock.lock()
        requestsToRetry.append(completion)
        let shouldRefresh = !isRefreshing
        lock.unlock()

        if shouldRefresh {
            refreshToken()
        } else {
            print("[AuthInterceptor] ⏳ 이미 토큰을 재발급 중이므로 큐에 추가됨")
        }
    }

    // ✅ 3. 토큰 재발급 로직
    private func refreshToken() {
        lock.lock()
        isRefreshing = true
        lock.unlock()

        print("[AuthInterceptor] 🔄 토큰 재발급 요청 시작...")

        refreshProvider.request(.refreshToken(refreshToken: UserDefaultHandler.refreshToken)) { [weak self] result in
            guard let self else { return }

            lock.lock(); defer { lock.unlock() }

            self.isRefreshing = false

            switch result {
            case .success(let response):
                do {
                    let decoded = try response.map(TokenRefreshResponseDTO.self)
                    UserDefaultHandler.accessToken = decoded.accessToken
                    UserDefaultHandler.refreshToken = decoded.refreshToken

                    print("[AuthInterceptor] ✅ 토큰 재발급 성공 - 저장소에 갱신 완료")
                    self.requestsToRetry.forEach { $0(.retry) }

                } catch {
                    print("[AuthInterceptor] ❌ 응답 디코딩 실패: \(error.localizedDescription)")
                    self.requestsToRetry.forEach { $0(.doNotRetry) }
                }

            case .failure(let error):
                print("[AuthInterceptor] ❌ 토큰 재발급 요청 실패: \(error.localizedDescription)")
                self.requestsToRetry.forEach { $0(.doNotRetry) }
            }

            self.requestsToRetry.removeAll()
        }
    }
}
