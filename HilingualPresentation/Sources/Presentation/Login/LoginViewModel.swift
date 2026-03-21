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
    private let deviceUseCase: DeviceUseCase
    private let tokenStore: TokenStoreUseCase

    private let homeSubject = PassthroughSubject<Void, Never>()
    private let onboardingSubject = PassthroughSubject<Void, Never>()
    private let errorSubject = PassthroughSubject<Error, Never>()

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
        input.loginTapped
            .handleEvents(receiveOutput: { _ in
                print("[LoginVM] 🔘 로그인 버튼 탭 감지됨")
            })
            .flatMap { [weak self] _ in
                self?.performLogin() ?? Empty<LoginResponseEntity, Never>().eraseToAnyPublisher()
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

    private func performLogin() -> AnyPublisher<LoginResponseEntity, Never> {
        print("[LoginVM] 🚀 소셜 로그인 UseCase 실행 시작")

        return socialLoginUseCase.execute()
            .flatMap { [weak self] result -> AnyPublisher<LoginResponseEntity, Error> in
                guard let self else {
                    return Fail(error: NSError(domain: "LoginViewModel", code: -1)).eraseToAnyPublisher()
                }
                return self.syncDevice(after: result)
            }
            .handleEvents(
                receiveOutput: { [weak self] result in
                    self?.handleLoginSuccess(result)
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

    private func syncDevice(after result: LoginResponseEntity) -> AnyPublisher<LoginResponseEntity, Error> {
        deviceUseCase.updateCurrentDevice()
            .handleEvents(receiveOutput: {
                print("[LoginVM] ✅ device API 성공")
                UserDefaults.standard.set(TimeZone.current.identifier, forKey: "lastKnownTimezone")
            })
            .map { result }
            .eraseToAnyPublisher()
    }

    private func handleLoginSuccess(_ result: LoginResponseEntity) {
        print("[LoginVM] ✅ 로그인 성공")
        print("[LoginVM] 🔑 accessToken: \(result.accessToken.prefix(10))...")
        print("[LoginVM] ♻️ refreshToken: \(result.refreshToken.prefix(10))...")
        print("[LoginVM] 🔍 isProfileCompleted: \(result.isProfileCompleted)")

        saveLoginState(result)
        navigateAfterLogin(result)
    }

    private func handleLoginFailure(_ error: Error) {
        print("[LoginVM] ❌ 로그인 실패: \(error.localizedDescription)")
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
