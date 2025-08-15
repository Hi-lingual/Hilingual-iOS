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
    private let service: VerifyCodeService

    public init(service: VerifyCodeService) {
        self.service = service
    }

    public func verifyCode(code: String) -> AnyPublisher<Void, Error> {
        service.verifyCode(code: code)
    }
}
