//
//  TabBarViewController.swift
//  HilingualPresentation
//
//  Created by 성현주 on 7/7/25.
//

import UIKit

public final class TabBarViewController: UITabBarController {

    // MARK: - Dependencies

    private let factory: ViewControllerFactory

    // MARK: - Init

    public init(diContainer: ViewControllerFactory) {
        self.factory = diContainer
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarAppearance()
        setupViewControllers()
    }

    // MARK: - Setup

    private func setupViewControllers() {
        let homeVC = makeTabItem(
            viewController: factory.makeHomeViewController(),
            title: "홈",
            selectedImageName: "ic_home_black_24_ios",
            unselectedImageName: "ic_home_gray_24_ios"
        )

    // TODO: - 실제 뷰컨으로 바꿔주세요.
        let vocabVC = makeTabItem(
            viewController: factory.makeWordBookViewController(),
            title: "단어장",
            selectedImageName: "ic_book_black_24_ios",
            unselectedImageName: "ic_book_gray_24_ios"
        )

        let communityVC = makeTabItem(
            viewController: factory.makeHomeViewController(),
            title: "커뮤니티",
            selectedImageName: "ic_community_black_24_ios",
            unselectedImageName: "ic_community_gray_24_ios"
        )

        let myVC = makeTabItem(
            viewController: factory.makeHomeViewController(),
            title: "마이",
            selectedImageName: "ic_my_black_24_ios",
            unselectedImageName: "ic_my_gray_24_ios"
        )

        viewControllers = [homeVC, vocabVC, communityVC, myVC]
    }

    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowColor = .gray200

        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.titleTextAttributes = [
            .font: UIFont.suit(.caption_m_12),
        ]
        itemAppearance.selected.titleTextAttributes = [
            .font: UIFont.suit(.caption_m_12),
        ]

        appearance.stackedLayoutAppearance = itemAppearance

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance

        tabBar.tintColor = .black
    }

    private func makeTabItem(
        viewController: UIViewController,
        title: String,
        selectedImageName: String,
        unselectedImageName: String
    ) -> UIViewController {
        viewController.tabBarItem = UITabBarItem(
            title: title,
            image: UIImage(named: unselectedImageName, in: .module, compatibleWith: nil)?
                .withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: selectedImageName, in: .module, compatibleWith: nil)?
                .withRenderingMode(.alwaysOriginal)
        )
        return viewController
    }
}
