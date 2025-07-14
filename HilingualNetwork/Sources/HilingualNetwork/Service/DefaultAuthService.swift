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
}


