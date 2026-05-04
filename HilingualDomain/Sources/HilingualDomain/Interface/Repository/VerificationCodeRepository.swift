//
//  VerifyCodeRepository.swift
//  HilingualDomain
//
//  Created by 성현주 on 8/14/25.
//


import Combine

public protocol VerificationCodeRepository {
    func verificationCode(code: String) -> AnyPublisher<Void, Error>
}
