//
//  SocialLoginUseCase.swift
//  HilingualDomain
//
//  Created by 성현주 on 7/15/25.
//

import Combine

public protocol SocialLoginUseCase {
    func execute(provider: SocialLoginProvider) -> AnyPublisher<LoginResponseEntity, Error>
    func executeRefresh(with refreshToken: String) -> AnyPublisher<LoginResponseEntity, Error>
}

public final class DefaultSocialLoginUseCase: SocialLoginUseCase {
    private let credentialRepository: SocialCredentialRepository
    private let authRepository: AuthRepository

    public init(
        credentialRepository: SocialCredentialRepository,
        authRepository: AuthRepository
    ) {
        self.credentialRepository = credentialRepository
        self.authRepository = authRepository
    }

    public func execute(provider: SocialLoginProvider) -> AnyPublisher<LoginResponseEntity, Error> {
        return credentialRepository.requestIdentityToken(provider: provider)
            .flatMap { [authRepository] token in
                authRepository.login(provider: provider, token: token)
            }
            .eraseToAnyPublisher()
    }

    public func executeRefresh(with refreshToken: String) -> AnyPublisher<LoginResponseEntity, Error> {
        return authRepository.refreshToken(token: refreshToken)
    }
}
