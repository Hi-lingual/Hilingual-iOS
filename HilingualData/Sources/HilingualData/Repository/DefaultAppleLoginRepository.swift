//
//  DefaultAppleLoginRepository.swift
//  HilingualData
//
//  Created by 성현주 on 7/8/25.
//

import Combine

import HilingualNetwork
import HilingualDomain

public final class DefaultAppleLoginRepository: AppleLoginRepository {
    private let service: AppleLoginService

    public init(service: AppleLoginService) {
        self.service = service
    }

    public func requestAppleIdentityToken() -> AnyPublisher<(String, String), Error> {
        return service.performAppleLogin()
    }
}
