//
//  DefaultVerifyCodeRepository.swift
//  HilingualData
//
//  Created by 성현주 on 8/14/25.
//


import Combine
import HilingualDomain
import HilingualNetwork

public final class DefaultVerificationCodeRepository: VerificationCodeRepository {
    private let service: VerificationCodeService

    public init(service: VerificationCodeService) {
        self.service = service
    }

    public func verificationCode(code: String) -> AnyPublisher<Void, Error> {
        service.verifyCode(code: code)
    }
}
