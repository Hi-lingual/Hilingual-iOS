//
//  AuthService.swift
//  HilingualNetwork
//
//  Created by 성현주 on 7/15/25.
//

import Foundation
import Combine

public protocol AuthService {
    func loginWithApple(token: String) -> AnyPublisher<LoginResponseDTO, Error>
    func refreshToken(token: String) -> AnyPublisher<TokenRefreshResponseDTO, Error>
}

public final class DefaultAuthService: BaseService<AuthAPI>, AuthService {    

    public func loginWithApple(token: String) -> AnyPublisher<LoginResponseDTO, Error> {
        let target = AuthAPI.socialLogin(provider: "APPLE", providerToken: token)

        return request(target, as: BaseAPIResponse<LoginResponseDTO>.self)
            .tryMap { response in
                return response.data
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

    public func refreshToken(token: String) -> AnyPublisher<TokenRefreshResponseDTO, Error> {
        let target = AuthAPI.refreshToken(refreshToken: token)

        return request(target, as: BaseAPIResponse<TokenRefreshResponseDTO>.self)
            .tryMap { response in
                return response.data
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}


