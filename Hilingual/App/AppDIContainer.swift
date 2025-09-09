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

    public func makeSplashViewController() -> SplashViewController {
        return SplashViewController(viewModel: makeSplashViewModel(), diContainer: self)
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
                diaryDetailUseCase: makeDiaryDetailUseCase(),
                feedbackUseCase: makeFeedbackUseCase()
            )
            return FeedbackViewController(viewModel: viewModel, diContainer:  self)
    }
    
    public func makeRecommendedExpressionViewController(diaryId: Int) -> RecommendedExpressionViewController {
//        return VocaViewController(viewModel: makeVocaViewModel(diaryId: diaryId), diContainer: self)
        let viewModel = RecommendedExpressionViewModel(
            diaryId: diaryId,
            recommendedExpressionUseCase: makeRecommendedExpressionUseCase(),
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

    public func makeNotificationViewController() -> NotificationViewController {
        return NotificationViewController(viewModel: makeNotificationViewModel(), diContainer: self)
    }

    public func makeNotificationDetailViewController(notiId: Int) -> NotificationDetailViewController {
        return NotificationDetailViewController(viewModel: makeNotificationDetailviewmodel(notiId: notiId), diContainer: self)
    }

    public func makeFeedViewController() -> FeedViewController {
        return FeedViewController(
            viewModel: makeFeedViewModel(),
            diContainer: self
        )
    }

    public func makeFeedListViewController(type: FeedListType) -> FeedListViewController {
        return FeedListViewController(
            viewModel: makeFeedViewModel(type: type),
            diContainer: self
        )
    }
    
    public func makeMyFeedProfileViewController() -> MyFeedProfileViewController {
        let likedVC = makeFeedProfileListViewController(type: .liked, userId: 0)
        let sharedVC = makeFeedProfileListViewController(type: .shared, userId: 0)
        
        return MyFeedProfileViewController(
            viewModel: makeFeedProfileViewModel(type: .liked, targetUserId: 0),
            diContainer: self,
            likedVC: likedVC,
            sharedVC: sharedVC
        )
    }

    public func makeUserFeedProfileViewController(userId: Int64) -> UserFeedProfileViewController {
        return UserFeedProfileViewController(
            viewModel: makeFeedProfileViewModel(type: .shared, targetUserId: userId),
            diContainer: self,
            targetUserId: userId
        )
    }

    public func makeFeedProfileListViewController(
        type: FeedProfileListType,
        userId: Int64
    ) -> FeedProfileViewController {
        // Presentation → Domain 변환
        let domainType: FeedProfileType = {
            switch type {
            case .liked: return .liked
            case .shared: return .shared
            }
        }()
        
        return FeedProfileViewController(
            viewModel: makeFeedProfileViewModel(type: domainType, targetUserId: userId),
            diContainer: self,
            type: type
        )
    }
    
    public func makeMypageViewController() -> MypageViewController {
        return MypageViewController(viewModel: makeMypageViewModel(), diContainer: self)
    }

    public func makeEditProfileViewController() -> EditProfileViewController {
        return EditProfileViewController(viewModel: makeEditProfileViewModel(), diContainer: self)
    }

    public func makeBlockUserViewController() -> BlockUserViewController {
        return BlockUserViewController(viewModel: makeBlockUserViewModel(), diContainer: self)
    }

    public func makeNotificationSettingViewController() -> NotificationSettingViewController {
        return NotificationSettingViewController(viewModel: makeNotificationViewModel(), diContainer: self)
    }

    public func makeFeedSearchViewController() -> FeedSearchViewController {
        return FeedSearchViewController(viewModel: makeFeedSearchViewModel(), diContainer: self)
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
        OnBoardingViewModel(useCase: makeOnBoardingUseCase(), uploadImageUseCase: makeUploadImageUseCase())
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
    private func makeDeleteDiaryUseCase() -> DeleteDiaryUseCase {
        return DefaultDeleteDiaryUseCase(repository: makeDeleteDiaryRepository())
    }
    
    private func makeDeleteDiaryRepository() -> DeleteDiaryRepository {
        return DefaultDeleteDiaryRepository(service: makeDiaryControlService())
    }
    
    private func makeDiaryControlService() -> DiaryControlService {
        return DefaultDiaryControlService()
    }
}

extension AppDIContainer {
    private func makePublishDiaryUseCase() -> PublishDiaryUseCase {
        return DefaultPublishDiaryUseCase(repository: makePublishDiaryRepository())
    }
    
    private func makePublishDiaryRepository() -> PublishDiaryRepository {
        return DefaultPublishDiaryRepository(service: makeDiaryControlService())
    }
}

extension AppDIContainer {
    private func makeDiaryDetailViewModel(diaryId: Int) -> DiaryDetailViewModel {
        return DiaryDetailViewModel(diaryId: diaryId, deleteDiaryUseCase: makeDeleteDiaryUseCase(), publishDiaryUseCase: makePublishDiaryUseCase())
    }
        
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
//        return DefaultHomeService()
        return MockHomeService()
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

//MARK: - MypageDIContainer

extension AppDIContainer {

    private func makeMypageUseCase() -> MypageUseCase {
        return DefaultMypageUseCase(authRepository: makeAuthRepository())
    }

    private func makeMypageViewModel() -> MypageViewModel {
        return MypageViewModel(mypageUseCase: makeMypageUseCase(), fetchUserProfileUseCase: makefetchUserProfileUseCase())
    }
}

//MARK: - BlockUserDIContainer

extension AppDIContainer {

    private func makeMockBlockUserService() -> BlockUserService {
        //TODO: - mock 변경하기!
        return MockBlockUserService()
    }

    private func makeBlockUserRepository() -> BlockUserRepository {
        return DefaultBlockUserRepository(service: makeMockBlockUserService())
    }
    private func makeBlockUserUsecase() -> BlockUserUseCase {
        return DefaultBlockUserUseCase(repository: makeBlockUserRepository())
    }

    private func makeBlockUserViewModel() -> BlockUserViewModel {
        return BlockUserViewModel(blockUserUseCase: makeBlockUserUsecase())
    }
}

// MARK: - NotificationDIContainer

extension AppDIContainer {

    private func makeNotificationSettingService() -> MockAlarmSettingService {
        return MockAlarmSettingService()
    }

    private func makeNotificationRepository() -> AlarmSettingRepository {
        return DefaultAlarmSettingRepository(service: makeNotificationSettingService())
    }

    private func makeNotificationUseCase() -> AlarmSettingUseCase {
        return DefaultAlarmSettingUseCase(repository: makeNotificationRepository())
    }

    private func makeNotificationViewModel() -> NotificationSettingViewModel {
        return NotificationSettingViewModel(useCase: makeNotificationUseCase())
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

// MARK: - SharedDiaryDIContainer

extension AppDIContainer {
    
    private func makeSharedDiaryService() -> SharedDiaryService {
        return DefaultSharedDiaryService()
    }
    
    private func makeSharedDiaryRepository() -> SharedDiaryRepository {
        return DefaultSharedDiaryRepository(service: makeSharedDiaryService())
    }
    
    private func makeSharedDiaryUseCase() -> SharedDiaryUseCase {
        return DefaultSharedDiaryUseCase(repository: makeSharedDiaryRepository())
    }
    
    private func makeSharedDiaryViewModel(diaryId: Int) -> SharedDiaryViewModel {
        return SharedDiaryViewModel(diaryId: diaryId, sharedDiaryUseCase: makeSharedDiaryUseCase(), toggleLikeUseCase: makeToggleLikeUseCase(), publishDiaryUseCase: makePublishDiaryUseCase(), blockUserUseCase: makeBlockUserUsecase())
    }
    
    func makeSharedDiaryViewController(diaryId: Int) -> SharedDiaryViewController {
        return SharedDiaryViewController(viewModel: makeSharedDiaryViewModel(diaryId: diaryId), diContainer: self, diaryId: diaryId)
    }
    
    func makeToggleLikeUseCase() -> ToggleLikeUseCase {
        return DefaultToggleLikeUseCase(repository: makeSharedDiaryRepository())
    }
}

// MARK: - FeedSearchDIContainer

extension AppDIContainer {
    
    private func makeFeedSearchService() -> MockFeedSearchService {
        return MockFeedSearchService()
    }

    private func makeFeedSearchRepository() -> FeedSearchRepository {
        return DefaultFeedSearchRepository(service: makeFeedSearchService())
    }

    private func makeFeedSearchUseCase() -> FeedSearchUseCase {
        return DefaultFeedSearchUseCase(repository: makeFeedSearchRepository())
    }

    private func makeFeedSearchViewModel() -> FeedSearchViewModel {
        return FeedSearchViewModel(useCase: makeFeedSearchUseCase())
    }
}

// MARK: - NotificiatoinDIContainer

extension AppDIContainer {
    private func makeNotificationService() -> MockNotificationService {
        return MockNotificationService()
    }

    private func makeNotificationRepository() -> NotificationRepository {
        return DefaultNotificationRepository(service: makeNotificationService())
    }

    private func makeNotificationuseCase() -> NotificationUseCase {
        return DefaultNotificationUseCase(repository: makeNotificationRepository())
    }

    private func makeNotificationViewModel() -> NotificationViewModel {
        return NotificationViewModel(useCase: makeNotificationuseCase())
    }
}

// MARK: - NotificationDetailDIContainer

extension AppDIContainer {
    private func makeNotificationDetailviewmodel(notiId: Int) -> NotificationDetailViewModel {
        return NotificationDetailViewModel(notiId: notiId, useCase: makeNotificationuseCase())
    }
}

// MARK: - FeedDIContainer
extension AppDIContainer {
    
    // ViewModel
    /// FeedViewController용 ViewModel
    private func makeFeedViewModel() -> FeedViewModel {
        return FeedViewModel(
            feedUseCase: makeFeedUseCase(),
            publishDiaryUseCase: makePublishDiaryUseCase(),
            toggleLikeUseCase: makeToggleLikeUseCase(),
            type: nil
        )
    }
    
    /// FeedListViewController용 ViewModel
    private func makeFeedViewModel(type: FeedListType) -> FeedViewModel {
        return FeedViewModel(
            feedUseCase: makeFeedUseCase(),
            publishDiaryUseCase: makePublishDiaryUseCase(),
            toggleLikeUseCase: makeToggleLikeUseCase(),
            type: type
        )
    }
    
    // UseCase
    private func makeFeedUseCase() -> FeedUseCase {
        DefaultFeedUseCase(repository: makeFeedRepository())
    }
    
    // Repository
    private func makeFeedRepository() -> FeedRepository {
        return DefaultFeedRepository(service: makeFeedService())
    }
    
    // Service
    
    private func makeFeedService() -> FeedService {
        return DefaultFeedService()
    }
    
//    private func makeFeedService() -> FeedService {
//        return MockFeedService()
//    }
}


// MARK: - FeedProfileDIContainer
extension AppDIContainer {
    
    // FeedProfile (공유/공감)
    private func makeFeedProfileViewModel(
        type: FeedProfileType,
        targetUserId: Int64
    ) -> FeedProfileViewModel {
        return FeedProfileViewModel(
            feedUseCase: makeFeedProfileUseCase(),
            profileInfoUseCase: makeFeedProfileInfoUseCase(),
            publishDiaryUseCase: makePublishDiaryUseCase(),
            toggleLikeUseCase: makeToggleLikeUseCase(),
            type: type,
            targetUserId: targetUserId
        )
    }
    
    private func makeFeedProfileUseCase() -> FeedProfileUseCase {
        DefaultFeedProfileUseCase(repository: makeFeedProfileRepository())
    }
    
    private func makeFeedProfileRepository() -> FeedProfileRepository {
        DefaultFeedProfileRepository(service: makeFeedProfileService())
    }
    
    private func makeFeedProfileService() -> FeedProfileService {
        return DefaultFeedProfileService()
    }

//    private func makeFeedProfileService() -> FeedProfileService {
//        return MockFeedProfileService()
//    }
        
    // FeedProfileInfo (프로필 정보)
    private func makeFeedProfileInfoUseCase() -> FeedProfileInfoUseCase {
        DefaultFeedProfileInfoUseCase(repository: makeFeedProfileInfoRepository())
    }
    
    private func makeFeedProfileInfoRepository() -> FeedProfileInfoRepository {
        DefaultFeedProfileInfoRepository(service: makeFeedProfileInfoService())
    }
    
    private func makeFeedProfileInfoService() -> FeedProfileInfoService {
        return DefaultFeedProfileInfoService()
    }

    //MARK: - UploadImageDIContainer

    private func makeUploadImageUseCase() -> UploadImageUseCase {
        DefaultUploadImageUseCase(repository: makeUploadImageRepository())
    }

    private func makeUploadImageRepository() -> DefaultPresignedImageUploadRepository {
        DefaultPresignedImageUploadRepository(service: makeUploadImageService())
    }

    private func makeUploadImageService() -> PresignedURLService {
        DefaultPresignedURLService()
    }

    //MARK: - EditProfileDIContainer

    private func makefetchUserProfileUseCase() -> FetchUserProfileUseCase {
        return DefaultFetchUserProfileUseCase(repository: makeUserProfileRepository())
    }

    private func makeUserProfileRepository() -> UserProfileRepository {
        return DefaultUserProfileRepository(service: makeUserProfileService())
    }

    private func makeUserProfileService() -> UserProfileService {
        return DefaultUserProfileService()
    }

    private func makeEditProfileViewModel() -> EditProfileViewModel {
        return EditProfileViewModel(fetchUserProfileUseCase: makefetchUserProfileUseCase(), uploadImageUseCase: makeUploadImageUseCase())
    }

}
