//
//  SocialLoginUseCase.swift
//  HilingualDomain
//
//  Created by 성현주 on 7/15/25.
//

import Combine

public protocol SocialLoginUseCase {
    func execute() -> AnyPublisher<LoginResponseEntity, Error>
    func executeAuto(with token: String) -> AnyPublisher<LoginResponseEntity, Error>
}
public final class DefaultSocialLoginUseCase: SocialLoginUseCase {
    private let appleLoginUseCase: AppleLoginUseCase
    private let authRepository: AuthRepository

    public init(
        appleLoginUseCase: AppleLoginUseCase,
        authRepository: AuthRepository
    ) {
        self.appleLoginUseCase = appleLoginUseCase
        self.authRepository = authRepository
    }

    public func execute() -> AnyPublisher<LoginResponseEntity, Error> {
        return appleLoginUseCase.executeAppleLogin()
            .flatMap { token, _ in
                self.authRepository.loginWithApple(token: token)
            }
            .eraseToAnyPublisher()
    }

    public func executeAuto(with token: String) -> AnyPublisher<LoginResponseEntity, Error> {
        return authRepository.loginWithApple(token: token)
    }
}
