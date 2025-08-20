//
//  MypageUseCase.swift
//  HilingualDomain
//
//  Created by 성현주 on 8/21/25.
//

import Foundation
import Combine

public protocol MypageUseCase {
    func logout() -> AnyPublisher<Void, Error>
}

public final class DefaultMypageUseCase: MypageUseCase {

    private let authRepository: AuthRepository

    public init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    public func logout() -> AnyPublisher<Void, Error> {
        return authRepository.logout()
    }
}
