//
//  DefaultAuthRepository.swift
//  HilingualData
//
//  Created by 성현주 on 7/15/25.
//

import Combine

import HilingualDomain
import HilingualNetwork

public final class DefaultAuthRepository: AuthRepository {
    private let service: AuthService

    public init(service: AuthService) {
        self.service = service
    }

    public func loginWithApple(token: String) -> AnyPublisher<LoginResponseEntity, Error> {
        return service.loginWithApple(token: token)
            .map { $0.toEntity() }
            .eraseToAnyPublisher()
    }
}
