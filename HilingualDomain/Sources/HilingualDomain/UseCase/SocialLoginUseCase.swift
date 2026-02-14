//
//  SocialLoginUseCase.swift
//  HilingualDomain
//
//  Created by 성현주 on 7/15/25.
//

import Combine

public protocol SocialLoginUseCase {
    func execute() -> AnyPublisher<LoginResponseEntity, Error>
    func executeRefresh(with refreshToken: String) -> AnyPublisher<LoginResponseEntity, Error>
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

    /// 애플 로그인 → 서버 로그인
    public func execute() -> AnyPublisher<LoginResponseEntity, Error> {
        return appleLoginUseCase.executeAppleLogin()
            .flatMap { token, _ in
                self.authRepository.loginWithApple(token: token)
            }
            .eraseToAnyPublisher()
    }

    /// refreshToken을 사용한 토큰 재발급
    public func executeRefresh(with refreshToken: String) -> AnyPublisher<LoginResponseEntity, Error> {
        return authRepository.refreshToken(token: refreshToken)
    }
}
