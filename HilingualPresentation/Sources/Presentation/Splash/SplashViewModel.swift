//
//  SplashViewModel.swift
//  HilingualPresentation
//
//  Created by 성현주 on 7/15/25.
//

import Foundation
import Combine
import HilingualDomain

public final class SplashViewModel: BaseViewModel {

    // MARK: - Input / Output

    public struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
    }

    public struct Output {
        let navigateToHome: AnyPublisher<Void, Never>
        let navigateToOnboarding: AnyPublisher<Void, Never>
        let navigateToLogin: AnyPublisher<Void, Never>
    }

    // MARK: - Dependencies

    private let tokenStore: TokenStoreUseCase
    private let socialLoginUseCase: SocialLoginUseCase

    // MARK: - Subjects

    private let homeSubject = PassthroughSubject<Void, Never>()
    private let onboardingSubject = PassthroughSubject<Void, Never>()
    private let loginSubject = PassthroughSubject<Void, Never>()

    // MARK: - Init

    public init(
        tokenStore: TokenStoreUseCase,
        socialLoginUseCase: SocialLoginUseCase
    ) {
        self.tokenStore = tokenStore
        self.socialLoginUseCase = socialLoginUseCase
    }

    // MARK: - Transform

    public func transform(input: Input) -> Output {
        input.viewDidLoad
            .sink { [weak self] _ in
                self?.handleAutoLogin()
            }
            .store(in: &cancellables)

        return Output(
            navigateToHome: homeSubject.eraseToAnyPublisher(),
            navigateToOnboarding: onboardingSubject.eraseToAnyPublisher(),
            navigateToLogin: loginSubject.eraseToAnyPublisher()
        )
    }

    // MARK: - Logic

    private func handleAutoLogin() {
        let token = tokenStore.loadAccessToken()
        
        if token.isEmpty {
            loginSubject.send()
            return
        }
        
        socialLoginUseCase.executeAuto(with: token)
            .sink(
                receiveCompletion: { (completion: Subscribers.Completion<Error>) in
                    if case .failure = completion {
                        self.loginSubject.send()
                    }
                },
                receiveValue: { (result: LoginResponseEntity) in
                    if result.isProfileCompleted {
                        self.homeSubject.send()
                    } else {
                        self.onboardingSubject.send()
                    }
                }
            )
            .store(in: &cancellables)
    }
}
