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
    private let authService: AuthService
    private let tokenStore: TokenStoreUseCase

    public init(
        authService: AuthService,
        tokenStore: TokenStoreUseCase
    ) {
        self.authService = authService
        self.tokenStore = tokenStore
    }

    public func loginWithApple(token: String) -> AnyPublisher<LoginResponseEntity, Error> {
        return authService.loginWithApple(token: token)
            .map { dto in
                let entity = dto.toEntity()
                self.tokenStore.save(
                    accessToken: entity.accessToken,
                    refreshToken: entity.refreshToken
                )
                return entity
            }
            .eraseToAnyPublisher()
    }
}

