//
//  ViewControllerFactory.swift
//  HilingualPresentation
//
//  Created by 성현주 on 7/5/25.
//

import Foundation

public protocol ViewControllerFactory {
    func makeSplashViewController() -> SplashViewController
    func makeTabBarViewController() -> TabBarViewController
    func makeLoginViewController() -> LoginViewController
    func makeOnboardingViewController() -> OnBoardingViewController
    func makeHomeViewController() -> HomeViewController
    func makeMypageViewController() -> MypageViewController
    func makeLoadingViewController() -> LoadingViewController
    func makeWordBookViewController() -> WordBookViewController
    func makeDiaryDetailViewController(diaryId: Int) -> DiaryDetailViewController
    func makeFeedbackViewController(diaryId: Int) -> FeedbackViewController
    func makeRecommendedExpressionViewController(diaryId: Int) -> RecommendedExpressionViewController
    func makeDiaryWritingViewController(
        topicData: (String, String)?,
        selectedDate: Date
    ) -> DiaryWritingViewController
    func makeVerificationCodeViewController() -> VerificationCodeViewController
    func makeFollowListViewController() -> FollowListViewController
    func makeSharedDiaryViewController(diaryId: Int) -> SharedDiaryViewController
    func makeFeedSearchViewController() -> FeedSearchViewController
    func makeNotificationViewController() -> NotificationViewController
    func makeNotificationDetailViewController(notiId: Int) -> NotificationDetailViewController
    func makeFeedViewController() -> FeedViewController
    func makeFeedListViewController(type: FeedListType) -> FeedListViewController
    func makeMyFeedProfileViewController() -> MyFeedProfileViewController
    func makeUserFeedProfileViewController(userId: Int64) -> UserFeedProfileViewController
    func makeFeedProfileListViewController(
        type: FeedProfileListType,
        userId: Int64
    ) -> FeedProfileListViewController
    func makeEditProfileViewController() -> EditProfileViewController
    func makeBlockUserViewController() -> BlockUserViewController
    func makeNotificationSettingViewController() -> NotificationSettingViewController
}
