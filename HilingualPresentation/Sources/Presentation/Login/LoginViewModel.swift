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
        let navigateToHome: AnyPublisher<Void, Never>
        let navigateToOnboarding: AnyPublisher<Void, Never>
        let error: AnyPublisher<Error, Never>
    }

    // MARK: - Dependencies

    private let appleLoginUseCase: AppleLoginUseCase
    private let socialLoginUseCase: SocialLoginUseCase

    private let homeSubject = PassthroughSubject<Void, Never>()
    private let onboardingSubject = PassthroughSubject<Void, Never>()
    private let errorSubject = PassthroughSubject<Error, Never>()

    // MARK: - Init

    public init(
        appleLoginUseCase: AppleLoginUseCase,
        socialLoginUseCase: SocialLoginUseCase
    ) {
        self.appleLoginUseCase = appleLoginUseCase
        self.socialLoginUseCase = socialLoginUseCase
    }

    // MARK: - Transform

    public func transform(input: Input) -> Output {
        let loginFlow: AnyPublisher<Void, Never> = input.loginTapped
            .flatMap { [weak self] _ -> AnyPublisher<Void, Never> in
                guard let self = self else {
                    return Empty<Void, Never>().eraseToAnyPublisher()
                }

                let appleLoginPublisher: AnyPublisher<(String, String), Error> = self.appleLoginUseCase.executeAppleLogin()

                return appleLoginPublisher
                    .flatMap { token, _ -> AnyPublisher<LoginResponseEntity, Error> in
                        self.socialLoginUseCase.login(with: token)
                    }
                    .handleEvents(receiveOutput: { [weak self] result in
                        if result.isProfileCompleted {
                            self?.homeSubject.send()
                        } else {
                            self?.onboardingSubject.send()
                        }
                    })
                    .map { _ in () } // LoginResponseEntity → Void
                    .catch { [weak self] error -> AnyPublisher<Void, Never> in
                        self?.errorSubject.send(error)
                        return Empty<Void, Never>().eraseToAnyPublisher()
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()

        loginFlow
            .sink { _ in }
            .store(in: &cancellables)

        return Output(
            navigateToHome: homeSubject.eraseToAnyPublisher(),
            navigateToOnboarding: onboardingSubject.eraseToAnyPublisher(),
            error: errorSubject.eraseToAnyPublisher()
        )
    }

}
