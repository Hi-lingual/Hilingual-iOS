//
//  AuthRepository.swift
//  HilingualDomain
//
//  Created by 성현주 on 7/15/25.
//

import Combine

public protocol AuthRepository {
    func login(provider: SocialLoginProvider, token: String) -> AnyPublisher<LoginResponseEntity, Error>
    func refreshToken(token: String) -> AnyPublisher<LoginResponseEntity, Error>
    func logout() -> AnyPublisher<Void, Error>
    func withdraw() -> AnyPublisher<Void, Error>
}
