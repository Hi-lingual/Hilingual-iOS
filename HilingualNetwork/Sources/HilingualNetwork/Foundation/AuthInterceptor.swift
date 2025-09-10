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

final class AuthInterceptor: RequestInterceptor {
    static let shared = AuthInterceptor()
    private init() {}

    private var cancellables = Set<AnyCancellable>()

    // MARK: - 요청 시 토큰 헤더 주입
    func adapt(_ urlRequest: URLRequest,
               for session: Session,
               completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest

        //재발급 api의 경우에는 토큰 주입안함
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

    func retry(_ request: Request,
               for session: Session,
               dueTo error: Error,
               completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }

        print("[AuthInterceptor] 🔄🔄🔄 401 감지 → 토큰 리프레시 시도")

        let refreshToken = UserDefaultHandler.refreshToken
        if refreshToken.isEmpty {
            completion(.doNotRetry)
            return
        }

        // 기존 서비스를 사용해서 토큰 재발급
        let authService = DefaultAuthService()
        authService.refreshToken(token: refreshToken)
            .sink { result in
                switch result {
                case .failure(let err):
                    print("[AuthInterceptor] ❌토큰 재발급 실패: \(err)")
                    completion(.doNotRetryWithError(err))
                case .finished:
                    break
                }
            } receiveValue: { dto in
                // 새 토큰 저장
                UserDefaultHandler.accessToken = dto.accessToken
                UserDefaultHandler.refreshToken = dto.refreshToken
                print("[AuthInterceptor] ✅ 토큰 재발급 성공 → 요청 재시도")
                completion(.retry)
            }
            .store(in: &cancellables)
    }
}
