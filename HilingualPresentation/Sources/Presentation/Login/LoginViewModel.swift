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
    private let tokenStore: TokenStoreUseCase

    private let homeSubject = PassthroughSubject<Void, Never>()
    private let onboardingSubject = PassthroughSubject<Void, Never>()
    private let errorSubject = PassthroughSubject<Error, Never>()

    public init(
        socialLoginUseCase: SocialLoginUseCase,
        tokenStore: TokenStoreUseCase
    ) {
        self.socialLoginUseCase = socialLoginUseCase
        self.tokenStore = tokenStore
    }

    public func transform(input: Input) -> Output {
        input.loginTapped
            .handleEvents(receiveOutput: { _ in
                print("[LoginVM] 🔘 로그인 버튼 탭 감지됨")
            })
            .flatMap { [weak self] _ -> AnyPublisher<LoginResponseEntity, Never> in
                guard let self else {
                    print("[LoginVM] ❗ self nil - 로그인 흐름 중단")
                    return Empty<LoginResponseEntity, Never>().eraseToAnyPublisher()
                }

                print("[LoginVM] 🚀 소셜 로그인 UseCase 실행 시작")

                return self.socialLoginUseCase.execute()
                    .handleEvents(
                        receiveOutput: { [weak self] result in
                            print("[LoginVM] ✅ 로그인 성공")
                            print("[LoginVM] 🔑 accessToken: \(result.accessToken.prefix(10))...")
                            print("[LoginVM] ♻️ refreshToken: \(result.refreshToken.prefix(10))...")
                            print("[LoginVM] 🔍 isProfileCompleted: \(result.isProfileCompleted)")

                            // 토큰 저장
                            self?.tokenStore.save(
                                accessToken: result.accessToken,
                                refreshToken: result.refreshToken
                            )
                            print("[LoginVM] 💾 토큰 저장 완료")

                            // isProfileCompleted 저장
                            UserDefaults.standard.set(result.isProfileCompleted, forKey: "isProfileCompleted")
                            print("[LoginVM] 💾 프로필 완료 여부 저장: \(result.isProfileCompleted)")

                            // 화면 전환
                            if result.isProfileCompleted ?? false {
                                print("[LoginVM] 🏠 홈 화면 이동")
                                self?.homeSubject.send()
                            } else {
                                print("[LoginVM] 🧭 온보딩 화면 이동")
                                self?.onboardingSubject.send()
                            }
                        },
                        receiveCompletion: { completion in
                            print("[LoginVM] 🔚 로그인 흐름 완료: \(completion)")
                        }
                    )
                    .catch { [weak self] error -> AnyPublisher<LoginResponseEntity, Never> in
                        print("[LoginVM] ❌ 로그인 실패: \(error.localizedDescription)")
                        self?.errorSubject.send(error)
                        return Empty().eraseToAnyPublisher()
                    }
                    .eraseToAnyPublisher()
            }
            .sink { _ in
                print("[LoginVM] 🔄 sink 완료")
            }
            .store(in: &cancellables)

        return Output(
            navigateToHome: homeSubject.eraseToAnyPublisher(),
            navigateToOnboarding: onboardingSubject.eraseToAnyPublisher(),
            error: errorSubject.eraseToAnyPublisher()
        )
    }
}
