//
//  VerificationCodeUseCase.swift
//  HilingualDomain
//
//  Created by 성현주 on 8/14/25.
//


import Combine

public protocol VerificationCodeUseCase {
    func execute(code: String) -> AnyPublisher<Void, Error>
}

public final class DefaultVerificationCodeUseCase: VerificationCodeUseCase {
    private let repository: VerificationCodeRepository

    public init(repository: VerificationCodeRepository) {
        self.repository = repository
    }

    public func execute(code: String) -> AnyPublisher<Void, Error> {
        repository.verifyCode(code: code)
    }
}
