//
//  AppDIContainer.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Foundation

import HilingualDomain
import HilingualData
import HilingualNetwork
import HilingualPresentation

// MARK: - DIContainer Entry Point

final class AppDIContainer: ViewControllerFactory {

    static let shared = AppDIContainer()

    private init() {
        injectBaseURL()
    }

    private func injectBaseURL() {
        NetworkEnvironment.shared = AppBaseURLProvider()
    }

    public func makeTabBarViewController() -> HilingualPresentation.TabBarViewController {
        return TabBarViewController(diContainer: self)
    }

    public func makeHomeViewController() -> HomeViewController {
        return HomeViewController(viewModel: makeHomeViewModel(), diContainer: self)
    }

    public func makeLoginViewController() -> LoginViewController {
        return LoginViewController(viewModel: makeLoginViewModel(), diContainer: self)
    }

    func makeOnboardingViewController() -> HilingualPresentation.OnBoardingViewController {
        return OnBoardingViewController(viewModel: makeOnBoardingViewModel(), diContainer: self)
    }
    
    func makeDiaryWritingViewController() -> HilingualPresentation.DiaryWritingViewController {
        return DiaryWritingViewController(viewModel: makeDiaryWritingViewModel(), diContainer: self)
    }

}


// MARK: - LoginDIContainer

extension AppDIContainer {

    private func makeAppleLoginService() -> AppleLoginService {
        DefaultAppleLoginService()
    }

    private func makeAppleLoginRepository() -> AppleLoginRepository {
        DefaultAppleLoginRepository(service: makeAppleLoginService())
    }

    private func makeAppleLoginUseCase() -> AppleLoginUseCase {
        DefaultAppleLoginUseCase(repository: makeAppleLoginRepository())
    }

    private func makeLoginViewModel() -> LoginViewModel {
        LoginViewModel(useCase: makeAppleLoginUseCase())
    }
}

// MARK: - OnBoardingDiContainer

extension AppDIContainer {
    
    private func makeOnBoardingService() -> OnBoardingService {
        DefaultOnBoardingService()
    }

    private func makeOnBoardingRepository() -> OnBoardingRepository {
        DefaultOnBoardingRepository(service: makeOnBoardingService())
    }

    private func makeOnBoardingUseCase() -> OnBoardingUseCase {
        DefaultOnBoardingUseCase(onBoardingRepository: makeOnBoardingRepository())
    }

    private func makeOnBoardingViewModel() -> OnBoardingViewModel {
        OnBoardingViewModel(useCase: makeOnBoardingUseCase())
    }
}

// MARK: - DiaryDIContainer

extension AppDIContainer {
    private func makeDiaryWritingViewModel() -> DiaryWritingViewModel {
        return DiaryWritingViewModel()
    }
}

// MARK: - HomeDIContainer

extension AppDIContainer {

    private func makeHomeService() -> HomeService {
        return DefaultHomeService()
    }

    private func makeHomeRepository() -> HomeRepository {
        return DefaultHomeRepository(service: makeHomeService())
    }

    private func makeHomeUseCase() -> HomeUseCase {
        return DefaultHomeUseCase(repository: makeHomeRepository())
    }

    private func makeHomeViewModel() -> HomeViewModel {
        return HomeViewModel(useCase: makeHomeUseCase())
    }
}
