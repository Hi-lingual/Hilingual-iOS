//
//  LoginViewModel.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Foundation
import Combine
import HilingualCore
import HilingualDomain

public final class LoginViewModel: BaseViewModel {
    
    public struct Input {
        let appleLoginTapped: AnyPublisher<Void, Never>
        let googleLoginTapped: AnyPublisher<Void, Never>
    }

    public struct Output {
        let navigateToHome: AnyPublisher<Void, Never>
        let navigateToOnboarding: AnyPublisher<Void, Never>
        let error: AnyPublisher<Error, Never>
        let isLoading: AnyPublisher<Bool, Never>
    }

    private let socialLoginUseCase: SocialLoginUseCase
    private let deviceUseCase: DeviceUseCase
    private let tokenStore: TokenStoreUseCase

    private let homeSubject = PassthroughSubject<Void, Never>()
    private let onboardingSubject = PassthroughSubject<Void, Never>()
    private let errorSubject = PassthroughSubject<Error, Never>()
    private let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)

    public init(
        socialLoginUseCase: SocialLoginUseCase,
        deviceUseCase: DeviceUseCase,
        tokenStore: TokenStoreUseCase
    ) {
        self.socialLoginUseCase = socialLoginUseCase
        self.deviceUseCase = deviceUseCase
        self.tokenStore = tokenStore
    }

    public func transform(input: Input) -> Output {
        Publishers.Merge(
            input.appleLoginTapped.map { SocialLoginProvider.apple },
            input.googleLoginTapped.map { SocialLoginProvider.google }
        )
            .filter { [weak self] _ in
                self?.isLoadingSubject.value == false
            }
            .handleEvents(receiveOutput: { [weak self] _ in
                print("[LoginVM] 🔘 로그인 버튼 탭 감지됨")
                self?.isLoadingSubject.send(true)
            })
            .flatMap { [weak self] provider in
                self?.performLogin(provider: provider) ?? Empty<LoginResponseEntity, Never>().eraseToAnyPublisher()
            }
            .sink { _ in
                print("[LoginVM] 🔄 sink 완료")
            }
            .store(in: &cancellables)

        return Output(
            navigateToHome: homeSubject.eraseToAnyPublisher(),
            navigateToOnboarding: onboardingSubject.eraseToAnyPublisher(),
            error: errorSubject.eraseToAnyPublisher(),
            isLoading: isLoadingSubject.eraseToAnyPublisher()
        )
    }

    private func performLogin(provider: SocialLoginProvider) -> AnyPublisher<LoginResponseEntity, Never> {
        print("[LoginVM] 🚀 소셜 로그인 UseCase 실행 시작")

        return socialLoginUseCase.execute(provider: provider)
            .handleEvents(
                receiveOutput: { [weak self] result in
                    guard let self else { return }
                    self.handleLoginSuccess(result)
                    self.syncDevice()
                },
                receiveCompletion: { completion in
                    print("[LoginVM] 🔚 로그인 흐름 완료: \(completion)")
                }
            )
            .catch { [weak self] error -> AnyPublisher<LoginResponseEntity, Never> in
                self?.handleLoginFailure(error)
                return Empty().eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    private func syncDevice() {
        Task { @MainActor in
            FCMTokenSyncService.shared.sessionDidAuthenticate()
        }

        deviceUseCase.updateCurrentDevice()
            .sink(
                receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        print("[LoginVM] ⚠️ device API 실패: \(error.localizedDescription)")
                    }
                },
                receiveValue: { _ in
                    print("[LoginVM] ✅ device API 성공")
                }
            )
            .store(in: &cancellables)
    }

    private func handleLoginSuccess(_ result: LoginResponseEntity) {
        print("[LoginVM] ✅ 로그인 성공")
        print("[LoginVM] 🔑 accessToken: \(result.accessToken.prefix(10))...")
        print("[LoginVM] ♻️ refreshToken: \(result.refreshToken.prefix(10))...")
        print("[LoginVM] 🔍 isProfileCompleted: \(result.isProfileCompleted)")

        HomeRecoveryStorage.clearSessionCache()
        saveLoginState(result)
        if let userId = result.userId {
            Task { @MainActor in
                AmplitudeManager.shared.updateUserId(userId)
            }
        }
        navigateAfterLogin(result)
    }

    private func handleLoginFailure(_ error: Error) {
        print("[LoginVM] ❌ 로그인 실패: \(error.localizedDescription)")
        isLoadingSubject.send(false)
        errorSubject.send(error)
    }

    private func saveLoginState(_ result: LoginResponseEntity) {
        tokenStore.save(
            accessToken: result.accessToken,
            refreshToken: result.refreshToken
        )
        print("[LoginVM] 💾 토큰 저장 완료")

        UserDefaults.standard.set(result.isProfileCompleted, forKey: "isProfileCompleted")
        print("[LoginVM] 💾 프로필 완료 여부 저장: \(result.isProfileCompleted)")
    }

    private func navigateAfterLogin(_ result: LoginResponseEntity) {
        if result.isProfileCompleted ?? false {
            print("[LoginVM] 🏠 홈 화면 이동")
            homeSubject.send()
        } else {
            print("[LoginVM] 🧭 온보딩 화면 이동")
            onboardingSubject.send()
        }
    }
}
