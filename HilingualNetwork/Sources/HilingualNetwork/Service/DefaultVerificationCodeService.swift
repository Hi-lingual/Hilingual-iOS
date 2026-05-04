//
//  DefaultVerificationCodeService.swift
//  HilingualNetwork
//
//  Created by 성현주 on 8/14/25.
//

import Foundation
import Combine
import Moya

public protocol VerificationCodeService {
    func verifyCode(code: String) -> AnyPublisher<Void, Error>
}

public final class DefaultVerificationCodeService: BaseService<OnBoardingAPI>, VerificationCodeService {
    public func verifyCode(code: String) -> AnyPublisher<Void, Error> {
        let requestDTO = VerifyCodeRequestDTO(code: code)

        return requestPlain(.verifyCode(requestDTO: requestDTO))
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
