//
//  ViewControllerFactory.swift
//  HilingualPresentation
//
//  Created by 성현주 on 7/5/25.
//

import Foundation

public protocol ViewControllerFactory {
    func makeTabBarViewController() -> TabBarViewController
    func makeLoginViewController() -> LoginViewController
    func makeOnboardingViewController() -> OnBoardingViewController
    func makeHomeViewController() -> HomeViewController
    func makeLoadingViewController() -> LoadingViewController
    func makeWordBookViewController() -> WordBookViewController
    func makeDiaryDetailViewController(diaryId: Int) -> DiaryDetailViewController
    func makeFeedbackViewController(diaryId: Int) -> FeedbackViewController
    func makeRecommendedExpressionViewController(diaryId: Int) -> RecommendedExpressionViewController
    func makeDiaryWritingViewController(
        topicData: (String, String)?,
        selectedDate: Date
    ) -> DiaryWritingViewController
    func makeFollowListViewController() -> FollowListViewController
}
