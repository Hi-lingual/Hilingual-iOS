//
//  AuthInterceptor.swift
//  HilingualNetwork
//
//  Created by 성현주 on 9/10/25.
//

import Foundation
import Moya
import Alamofire
import Combine

public final class AuthInterceptor: RequestInterceptor {
    public static let shared = AuthInterceptor()
    private init() {}

    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private var isRefreshing = false
    private var requestsToRetry: [(RetryResult) -> Void] = []

    // MARK: - 요청 시 토큰 헤더 주입
    
    public func adapt(_ urlRequest: URLRequest,
                      for session: Session,
                      completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest

        // 재발급 API는 토큰 주입 안 함
        if request.url?.path.contains("/users/reissue") == true {
            completion(.success(request))
            return
        }

        let accessToken = UserDefaultHandler.accessToken
        if !accessToken.isEmpty {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }

        completion(.success(request))
    }

    // MARK: - 401 발생 시 토큰 재발급 후 재시도

    public func retry(_ request: Request,
                      for session: Session,
                      dueTo error: Error,
                      completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }

        print("[AuthInterceptor] 🔄 401 감지 → 토큰 리프레시 시도")

        requestsToRetry.append(completion)

        guard !isRefreshing else { return }
        isRefreshing = true

        let refreshToken = UserDefaultHandler.refreshToken
        if refreshToken.isEmpty {
            completeAllWithFailure(NetworkError.refreshFailed)
            notifySessionExpired()
            return
        }

        DefaultAuthService().refreshToken(token: refreshToken)
            .sink { [weak self] result in
                switch result {
                case .failure(let err):
                    print("[AuthInterceptor] ❌ 토큰 재발급 실패: \(err)")
                    self?.completeAllWithFailure(err)
                    self?.notifySessionExpired()
                case .finished:
                    break
                }
            } receiveValue: { [weak self] dto in
                guard let self else { return }
                UserDefaultHandler.accessToken = dto.accessToken
                UserDefaultHandler.refreshToken = dto.refreshToken
                print("[AuthInterceptor] ✅ 토큰 재발급 성공 → 요청 재시도")
                self.completeAllWithRetry()
            }
            .store(in: &cancellables)
    }

    // MARK: - Pending 요청 처리

    private func completeAllWithRetry() {
        isRefreshing = false
        let completions = requestsToRetry
        requestsToRetry.removeAll()
        completions.forEach { $0(.retry) }
    }

    private func completeAllWithFailure(_ error: Error) {
        isRefreshing = false
        let completions = requestsToRetry
        requestsToRetry.removeAll()
        completions.forEach { $0(.doNotRetryWithError(error)) }
    }

    // MARK: - 세션 만료 이벤트 발행

    private func notifySessionExpired() {
        NotificationCenter.default.post(
            name: Notification.Name("SessionExpired"),
            object: nil
        )
    }
}
