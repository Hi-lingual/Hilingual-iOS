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
            #if DEBUG
            let dummyResponse = LoginResponseDTO(
                accessToken: "debug_access_token",
                refreshToken: "debug_refresh_token",
                isProfileCompleted: false
            )
            return Just(dummyResponse)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
            #else
            let target = AuthAPI.socialLogin(provider: "APPLE", providerToken: token)
            return request(target, as: BaseAPIResponse<LoginResponseDTO>.self)
                .tryMap { response in
                    return response.data
                }
                .mapError { $0 as Error }
                .eraseToAnyPublisher()
            #endif
        }

    public func refreshToken(token: String) -> AnyPublisher<TokenRefreshResponseDTO, Error> {
           #if DEBUG
           let dummyResponse = TokenRefreshResponseDTO(
               accessToken: "debug_refreshed_access_token",
               refreshToken: "debug_refreshed_refresh_token"
           )
           return Just(dummyResponse)
               .setFailureType(to: Error.self)
               .eraseToAnyPublisher()
           #else
           let target = AuthAPI.refreshToken(refreshToken: token)
           return request(target, as: BaseAPIResponse<TokenRefreshResponseDTO>.self)
               .tryMap { response in
                   return response.data
               }
               .mapError { $0 as Error }
               .eraseToAnyPublisher()
           #endif
       }
}


