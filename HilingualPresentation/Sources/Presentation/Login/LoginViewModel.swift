//
//  LoginViewModel.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Foundation
import Combine

import HilingualDomain

public final class LoginViewModel: BaseViewModel {

    // MARK: - Input / Output

    public struct Input {
        let loginTapped: AnyPublisher<Void, Never>
    }

    public struct Output {
        let loginResult: AnyPublisher<(String, String), Error>
    }

    // MARK: - Dependencies

    private let useCase: AppleLoginUseCase

    // MARK: - Init

    public init(useCase: AppleLoginUseCase) {
        self.useCase = useCase
    }

    // MARK: - Transform

    public func transform(input: Input) -> Output {
        let loginResult = input.loginTapped
            .compactMap { [weak self] in self }
            .flatMap { $0.useCase.executeAppleLogin() }
            .eraseToAnyPublisher()

        return Output(loginResult: loginResult)
    }
}
