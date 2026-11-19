//
//  SocialCredentialRepository.swift
//  HilingualDomain
//
//  Created by 성현주 on 7/8/25.
//

import Combine

public protocol SocialCredentialRepository {
    func requestIdentityToken(provider: SocialLoginProvider) -> AnyPublisher<String, Error>
}
