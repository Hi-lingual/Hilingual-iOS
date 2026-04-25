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
        let navigateToLoginOnBoarding: AnyPublisher<Void, Never>
    }

    // MARK: - Dependencies

    private let tokenStore: TokenStoreUseCase
    private let socialLoginUseCase: SocialLoginUseCase
    private let deviceUseCase: DeviceUseCase

    // MARK: - Subjects

    private let homeSubject = PassthroughSubject<Void, Never>()
    private let onboardingSubject = PassthroughSubject<Void, Never>()
    private let loginSubject = PassthroughSubject<Void, Never>()
    private let loginOnBoardingSubject = PassthroughSubject<Void, Never>()

    // MARK: - Init

    public init(
        tokenStore: TokenStoreUseCase,
        socialLoginUseCase: SocialLoginUseCase,
        deviceUseCase: DeviceUseCase
    ) {
        self.tokenStore = tokenStore
        self.socialLoginUseCase = socialLoginUseCase
        self.deviceUseCase = deviceUseCase
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
            navigateToLogin: loginSubject.eraseToAnyPublisher(),
            navigateToLoginOnBoarding: loginOnBoardingSubject.eraseToAnyPublisher()
        )
    }

    // MARK: - Logic

    private func handleAutoLogin() {
        let accessToken = tokenStore.loadAccessToken()
        let refreshToken = tokenStore.loadRefreshToken()

        print("[SplashVM] 엑세스 토큰: \(accessToken.isEmpty ? "없음" : "있음")")
        print("[SplashVM] 리프래시 토큰: \(refreshToken.isEmpty ? "없음" : "있음")")

        guard !accessToken.isEmpty, !refreshToken.isEmpty else {
            let hasLoggedInBefore = UserDefaults.standard.bool(forKey: "hasLoggedInBefore")
            print("[SplashVM] hasLoggedInBefore: \(hasLoggedInBefore)")
            if hasLoggedInBefore {
                print("[SplashVM] ❌ 토큰 없음 → 로그인 화면으로 이동")
                loginSubject.send()
            } else {
                print("[SplashVM] ❌ 토큰 없음 → 로그인 온보딩 화면으로 이동")
                loginOnBoardingSubject.send()
            }
            return
        }

        print("[SplashVM] 🔁 토큰 재발급 시도")

        socialLoginUseCase.executeRefresh(with: refreshToken)
            .flatMap { [weak self] result -> AnyPublisher<LoginResponseEntity, Error> in
                guard let self else {
                    return Fail(error: NSError(domain: "SplashViewModel", code: -1)).eraseToAnyPublisher()
                }
                return self.syncDevice(after: result)
            }
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        print("[SplashVM] ❌ 자동 로그인 실패 → 로그인 이동 (\(error))")
                        self?.loginSubject.send()
                    }
                },
                receiveValue: { [weak self] response in
                    print("[SplashVM] ✅ 자동 로그인 성공")

                    self?.tokenStore.save(
                        accessToken: response.accessToken,
                        refreshToken: response.refreshToken
                    )

//                    #if DEBUG
//                    let isProfileCompleted = true
//                    print("[SplashVM] ⚙️ DEBUG 모드라서 → isProfileCompleted 강제 true임 ㅋㅋ")
//                    #else
                    let isProfileCompleted = UserDefaults.standard.bool(forKey: "isProfileCompleted")
                    print("[SplashVM] 로컬 프로필 완료 여부: \(isProfileCompleted)")
//                    #endif

                    if isProfileCompleted {
                        print("[SplashVM] 홈 화면 이동")
                        self?.homeSubject.send()
                    } else {
                        print("[SplashVM] 로그인 화면 이동")
                        self?.loginSubject.send()
                    }
                }
            )
            .store(in: &cancellables)
    }

    private func syncDevice(after response: LoginResponseEntity) -> AnyPublisher<LoginResponseEntity, Error> {
        deviceUseCase.updateCurrentDevice()
            .handleEvents(receiveOutput: {
                print("[SplashVM] ✅ device API 성공")
            })
            .map { response }
            .eraseToAnyPublisher()
    }
}
