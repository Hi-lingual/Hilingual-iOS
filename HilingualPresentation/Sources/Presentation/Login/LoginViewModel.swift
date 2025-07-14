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

    public struct Input {
        let loginTapped: AnyPublisher<Void, Never>
    }

    public struct Output {
        let navigateToHome: AnyPublisher<Void, Never>
        let navigateToOnboarding: AnyPublisher<Void, Never>
        let error: AnyPublisher<Error, Never>
    }

    private let socialLoginUseCase: SocialLoginUseCase

    private let homeSubject = PassthroughSubject<Void, Never>()
    private let onboardingSubject = PassthroughSubject<Void, Never>()
    private let errorSubject = PassthroughSubject<Error, Never>()

    public init(
        socialLoginUseCase: SocialLoginUseCase
    ) {
        self.socialLoginUseCase = socialLoginUseCase
    }

    public func transform(input: Input) -> Output {
        input.loginTapped
            .flatMap { [weak self] _ -> AnyPublisher<LoginResponseEntity, Never> in
                guard let self else {
                    return Empty<LoginResponseEntity, Never>().eraseToAnyPublisher()
                }

                return self.socialLoginUseCase.execute()
                    .handleEvents(
                        receiveOutput: { [weak self] (result: LoginResponseEntity) in
                            print("🟢 로그인 성공 - isProfileCompleted: \(result.isProfileCompleted)")
                            if result.isProfileCompleted {
                                self?.homeSubject.send()
                            } else {
                                self?.onboardingSubject.send()
                            }
                        },
                        receiveCompletion: { (completion: Subscribers.Completion<Error>) in
                            print("✅ 로그인 흐름 완료: \(completion)")
                        }
                    )
                    .catch { [weak self] error -> AnyPublisher<LoginResponseEntity, Never> in
                        print("❌ 로그인 실패: \(error)")
                        self?.errorSubject.send(error)
                        return Empty().eraseToAnyPublisher()
                    }
                    .eraseToAnyPublisher()
            }
            .sink { _ in }
            .store(in: &cancellables)

        return Output(
            navigateToHome: homeSubject.eraseToAnyPublisher(),
            navigateToOnboarding: onboardingSubject.eraseToAnyPublisher(),
            error: errorSubject.eraseToAnyPublisher()
        )
    }
}
