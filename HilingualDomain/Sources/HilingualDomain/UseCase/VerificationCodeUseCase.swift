//
//  VerificationCodeUseCase.swift
//  HilingualDomain
//
//  Created by 성현주 on 8/14/25.
//


import Combine

public protocol VerificationCodeUseCase {
    func verficationCode(code: String) -> AnyPublisher<Void, Error>
}

public final class DefaultVerificationCodeUseCase: VerificationCodeUseCase {
    private let repository: VerificationCodeRepository

    public init(repository: VerificationCodeRepository) {
        self.repository = repository
    }

    public func verficationCode(code: String) -> AnyPublisher<Void, Error> {
        repository.verificationCode(code: code)
    }
}
