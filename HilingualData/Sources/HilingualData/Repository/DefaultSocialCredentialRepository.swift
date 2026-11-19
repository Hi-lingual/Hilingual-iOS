//
//  DefaultSocialCredentialRepository.swift
//  HilingualData
//
//  Created by 성현주 on 7/8/25.
//

import Combine

import HilingualNetwork
import HilingualDomain

public final class DefaultSocialCredentialRepository: SocialCredentialRepository {
    private let appleLoginService: AppleLoginService
    private let googleLoginService: GoogleLoginService

    public init(
        appleLoginService: AppleLoginService,
        googleLoginService: GoogleLoginService
    ) {
        self.appleLoginService = appleLoginService
        self.googleLoginService = googleLoginService
    }

    public func requestIdentityToken(provider: SocialLoginProvider) -> AnyPublisher<String, Error> {
        switch provider {
        case .apple:
            return appleLoginService.performAppleLogin()
                .map(\.0)
                .eraseToAnyPublisher()
        case .google:
            return googleLoginService.performGoogleLogin()
        }
    }
}
