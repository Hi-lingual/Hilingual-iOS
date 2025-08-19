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
    
    public func makeDiaryDetailViewController(diaryId: Int) -> DiaryDetailViewController {
        return DiaryDetailViewController(
            viewModel: makeDiaryDetailViewModel(diaryId: diaryId),
            diContainer: self,
            diaryId: diaryId
        )
    }
    
    public func makeFeedbackViewController(diaryId: Int) -> FeedbackViewController {
//        return FeedbackViewController(viewModel: makeFeedbackViewModel(diaryId: diaryId), diContainer: self)
        let viewModel = FeedbackViewModel(
                diaryId: diaryId,
                diaryDetailUseCase: MockDiaryDetailUseCase(),
                feedbackUseCase: MockFeedbackUseCase()
            )
            return FeedbackViewController(viewModel: viewModel, diContainer:  self)
    }
    
    public func makeRecommendedExpressionViewController(diaryId: Int) -> RecommendedExpressionViewController {
//        return VocaViewController(viewModel: makeVocaViewModel(diaryId: diaryId), diContainer: self)
        let viewModel = RecommendedExpressionViewModel(
            diaryId: diaryId,
            recommendedExpressionUseCase: MockRecommendedUseCase(),
            toggleBookmarkUseCase: makeToggleBookmarkUseCase()
        )
        return RecommendedExpressionViewController(viewModel: viewModel, diContainer: self)
    }

    func makeOnboardingViewController() -> HilingualPresentation.OnBoardingViewController {
        return OnBoardingViewController(viewModel: makeOnBoardingViewModel(), diContainer: self)
    }
    
    func makeDiaryWritingViewController(
        topicData: (String, String)? = ("테스트 주제", "Test Topic"), // 임의 주제
        selectedDate: Date
    ) -> DiaryWritingViewController {
        
        let useCase = DummyDiaryWritingUseCase()
        let viewModel = DiaryWritingViewModel(diaryWritingUseCase: useCase)
        
        return DiaryWritingViewController(
            viewModel: viewModel,
            diContainer: self,
            topicData: topicData,
            selectedDate: selectedDate
        )
        
//        return DiaryWritingViewController(
//            viewModel: makeDiaryWritingViewModel(),
//            diContainer: self,
//            topicData: topicData,
//            selectedDate: selectedDate
//        )
    }

    func makeLoadingViewController() -> HilingualPresentation.LoadingViewController {
        return LoadingViewController(viewModel: makeLoadingViewModel(), diContainer: self)
    }
    public func makeWordBookViewController() -> WordBookViewController {
        return WordBookViewController(viewModel: makeWordBookViewmodel(), diContainer: self)
    }
    public func makeVerificationCodeViewController() -> VerificationCodeViewController {
        return VerificationCodeViewController(viewModel: makeVerificationCodeViewModel(), diContainer: self)
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

// MARK: - VerificationCodeDIContainer

extension AppDIContainer {
    //TODO: MOCK 제거
    private func makeVerificationCodeService() -> VerificationCodeService {
        return MockVerificationCodeService()
    }

    private func makeVerificationCodeRespository() -> VerificationCodeRepository {
        return DefaultVerificationCodeRepository(service: makeVerificationCodeService())
    }

    private func makeVerifyCodeUseCase() -> VerificationCodeUseCase {
        return DefaultVerificationCodeUseCase(repository: makeVerificationCodeRespository())
    }

    private func makeVerificationCodeViewModel() -> VerificationCodeViewModel {
        return VerificationCodeViewModel(verifyCodeUseCase: makeVerifyCodeUseCase())
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
    
    private func makeDiaryWritingService() -> DiaryWritingService {
        return DefaultDiaryWritingService()
    }

    private func makeDiaryWritingRepository() -> DiaryWritingRepository {
        return DefaultDiaryWritingRepository(service: makeDiaryWritingService())
    }

    private func makeDiaryWritingUseCase() -> DiaryWritingUseCase {
        return DefaultDiaryWritingUseCase(repository: makeDiaryWritingRepository())
    }

    private func makeDiaryWritingViewModel() -> DiaryWritingViewModel {
        return DiaryWritingViewModel(diaryWritingUseCase: makeDiaryWritingUseCase())
    }
}

// MARK: - DiaryDetailDIContainer

extension AppDIContainer {
    private func makeDiaryDetailViewModel(diaryId: Int) -> DiaryDetailViewModel {
        return DiaryDetailViewModel(diaryId: diaryId)
    }
    
    // MARK: - diaryId 수정
    
    private func makeFeedbackViewModel(diaryId: Int) -> FeedbackViewModel {
        return FeedbackViewModel(diaryId: diaryId, diaryDetailUseCase: makeDiaryDetailUseCase(), feedbackUseCase: makeFeedbackUseCase())
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
    
    // MARK: - diaryId 수정
    
    private func makeRecommendedExpressionViewModel(diaryId: Int) -> RecommendedExpressionViewModel {
        return RecommendedExpressionViewModel(diaryId: diaryId, recommendedExpressionUseCase: makeRecommendedExpressionUseCase(), toggleBookmarkUseCase: makeToggleBookmarkUseCase())
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
    
    private func makeRecommendedExpressionUseCase() -> RecommendedExpressionUseCase {
        return DefaultRecommendedExpressionUseCase(repository: makeRecommendedRepository())
    }
    
    private func makeRecommendedRepository() -> RecommendedExpressionRepository {
        return DefaultRecommendedExpressionRepository(service: makeRecommendedService())
    }
    
    private func makeRecommendedService() -> RecommendedExpressionService {
        return DefaultRecommendedExpressionService()
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
        return LoadingViewModel(diaryWritingUseCase: makeDiaryWritingUseCase())
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

// MARK: - FollowListDIContainer

extension AppDIContainer {
    
    private func makeFollowListService() -> MockFollowListService {
        return MockFollowListService() // TODO: 실제 API 서비스로 교체
    }
    
    private func makeFollowListRepository() -> FollowListRepository {
        return DefaultFollowListRepository(service: makeFollowListService())
    }
    
    private func makeFollowListUseCase() -> FollowListUseCase {
        return DefaultFollowListUseCase(repository: makeFollowListRepository())
    }
    
    private func makeFollowListViewModel() -> FollowListViewModel {
        return FollowListViewModel(followListUseCase: makeFollowListUseCase())
    }
    
    func makeFollowListViewController() -> FollowListViewController {
        let viewController = FollowListViewController(
            viewModel: makeFollowListViewModel(),
            diContainer: self
        )
        return viewController
    }
}

