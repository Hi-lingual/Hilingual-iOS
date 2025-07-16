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
    
    public func makeDiaryDetailViewController() -> DiaryDetailViewController {
        return DiaryDetailViewController(viewModel: makeDiaryDetailViewModel(), diContainer: self)
    }
    
    public func makeFeedbackViewController() -> FeedbackViewController {
        return FeedbackViewController(viewModel: makeFeedbackViewModel(), diContainer: self)
    }
    
    public func makeVocaViewController() -> VocaViewController {
        return VocaViewController(viewModel: makeVocaViewModel(), diContainer: self)
    }

    func makeOnboardingViewController() -> HilingualPresentation.OnBoardingViewController {
        return OnBoardingViewController(viewModel: makeOnBoardingViewModel(), diContainer: self)
    }
    
    func makeDiaryWritingViewController() -> HilingualPresentation.DiaryWritingViewController {
        return DiaryWritingViewController(viewModel: makeDiaryWritingViewModel(), diContainer: self)
    }

    func makeLoadingViewController() -> HilingualPresentation.LoadingViewController {
        return LoadingViewController(viewModel: makeLoadingViewModel(), diContainer: self)
    }
    public func makeWordBookViewController() -> WordBookViewController {
        return WordBookViewController(viewModel: makeWordBookViewmodel(), diContainer: self)
    }

}
// MARK: - SplashDIContainer

extension AppDIContainer {

    func makeSplashViewModel() -> SplashViewModel {
        return SplashViewModel(
            tokenStore: makeTokenStoreUseCase(),
            socialLoginUseCase: makeSocialLoginUseCase()
        )
    }

    func makeSplashViewController() -> SplashViewController {
        return SplashViewController(
            viewModel: makeSplashViewModel(),
            diContainer: self
        )
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

    private func makeTokenStoreUseCase() -> TokenStoreUseCase {
        DefaultTokenStore()
    }

    private func makeAuthRepository() -> AuthRepository {
        DefaultAuthRepository(
            authService: makeAuthService(),
            tokenStore: makeTokenStoreUseCase()
        )
    }

    private func makeAuthService() -> AuthService {
         DefaultAuthService()
     }


    private func makeSocialLoginUseCase() -> SocialLoginUseCase {
        DefaultSocialLoginUseCase(appleLoginUseCase: makeAppleLoginUseCase(), authRepository: makeAuthRepository())
    }

    private func makeLoginViewModel() -> LoginViewModel {
        return LoginViewModel(
            socialLoginUseCase: makeSocialLoginUseCase(), tokenStore: makeTokenStoreUseCase()
        )
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

// MARK: - DiaryDetailDIContainer

extension AppDIContainer {
    private func makeDiaryDetailViewModel() -> DiaryDetailViewModel {
        return DiaryDetailViewModel()
    }
    
    private func makeFeedbackViewModel() -> FeedbackViewModel {
        return FeedbackViewModel(diaryDetailUseCase: makeDiaryDetailUseCase(), feedbackUseCase: makeFeedbackUseCase())
    }
    
    private func makeFeedbackUseCase() -> FeedbackUseCase {
        return DefaultFeedbackUseCase(repository: makeFeedbackRepository())
    }
    
    private func makeFeedbackRepository() -> FeedbackRepository {
        return DefaultFeedbackRepository(service: makeFeedbackService())
    }
    
    private func makeFeedbackService() -> FeedbackService {
        return DefaultFeedbackService()
    }
    
    private func makeVocaViewModel() -> VocaViewModel {
        return VocaViewModel(recommendedVocaUseCase: makeVocaUseCase())
    }
    
    private func makeDiaryDetailUseCase() -> DiaryDetailUseCase {
        return DefaultDiaryDetailUseCase(repository: makeDiaryDetailRepository())
    }
    
    private func makeDiaryDetailRepository() -> DiaryDetailRepository {
        return DefaultDiaryDetailRepository(service: makeDiaryDetailService())
    }
    
    private func makeDiaryDetailService() -> DiaryDetailService {
        return DefaultDiaryDetailService()
    }
    
    private func makeVocaUseCase() -> RecommendedUseCase {
        return DefaultRecommendedUseCase(repository: makeRecommendedRepository())
    }
    
    private func makeRecommendedRepository() -> RecommendedVocaRepository {
        return DefaultRecommendedVocaRepository(service: makeRecommendedService())
    }
    
    private func makeRecommendedService() -> RecommendedVocaService {
        return DefaultRecommendedVocaService()
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

// MARK: - LoadingDIContainer

extension AppDIContainer {
    private func makeLoadingViewModel() -> LoadingViewModel {
        return LoadingViewModel()
    }
}


// MARK: - WordBookDIContainer

extension AppDIContainer {
    private func makeWordBookService() -> WordBookService {
        return DefaultWordBookService()
    }

    private func makeWordBookRepository() -> WordBookRepository {
        return DefaultWordRepository(service: makeWordBookService())
    }

    private func makeWordBookUseCase() -> WordBookUseCase {
        return DefaultWordBookUseCase(repository: makeWordBookRepository())
    }

    private func makeToggleBookmarkUseCase() -> ToggleBookmarkUseCase {
        return DefaultToggleBookmarkUseCase(repository: makeWordBookRepository())
    }

    private func makeWordBookViewmodel() -> WordBookViewModel {
        return WordBookViewModel(fetchWordListUseCase: makeWordBookUseCase(), toggleBookmarkUseCase: makeToggleBookmarkUseCase())
    }
}
