//
//  AuthRepository.swift
//  HilingualDomain
//
//  Created by 성현주 on 7/15/25.
//

import Combine

public protocol AuthRepository {
    func loginWithApple(token: String) -> AnyPublisher<LoginResponseEntity, Error>
}
