//
//  AppleLoginUseCase.swift
//  HilingualDomain
//
//  Created by 성현주 on 7/8/25.
//

import Combine

public protocol AppleLoginUseCase {
    func executeAppleLogin() -> AnyPublisher<(String, String), Error>
}

public final class DefaultAppleLoginUseCase: AppleLoginUseCase {    
    private let repository: AppleLoginRepository

    public init(repository: AppleLoginRepository) {
        self.repository = repository
    }

    public func executeAppleLogin() -> AnyPublisher<(String, String), Error> {
        return repository.requestAppleIdentityToken()
    }
}
