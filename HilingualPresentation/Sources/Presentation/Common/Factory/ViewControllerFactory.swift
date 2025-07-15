//
//  ViewControllerFactory.swift
//  HilingualPresentation
//
//  Created by 성현주 on 7/5/25.
//

public protocol ViewControllerFactory {
    func makeTabBarViewController() -> TabBarViewController
    func makeLoginViewController() -> LoginViewController
    func makeOnboardingViewController() -> OnBoardingViewController
    func makeHomeViewController() -> HomeViewController
    func makeLoadingViewController() -> LoadingViewController
    func makeDiaryDetailViewController() -> DiaryDetailViewController
    func makeFeedbackViewController() -> FeedbackViewController
    func makeVocaViewController() -> VocaViewController
}
