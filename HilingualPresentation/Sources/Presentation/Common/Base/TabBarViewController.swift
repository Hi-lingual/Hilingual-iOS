//
//  TabBarViewController.swift
//  HilingualPresentation
//
//  Created by 성현주 on 7/7/25.
//

import UIKit

public final class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

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
        delegate = self
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

        let vocabVC = makeTabItem(
            viewController: factory.makeWordBookViewController(),
            title: "단어장",
            selectedImageName: "ic_book_black_24_ios",
            unselectedImageName: "ic_book_gray_24_ios"
        )

        let feedVC = makeTabItem(
            viewController: factory.makeFeedViewController(),
            title: "피드",
            selectedImageName: "ic_community_black_24_ios",
            unselectedImageName: "ic_community_gray_24_ios"
        )

        let myVC = makeTabItem(
            viewController: factory.makeMypageViewController(),
            title: "마이",
            selectedImageName: "ic_my_black_24_ios",
            unselectedImageName: "ic_my_gray_24_ios"
        )

        viewControllers = [homeVC, vocabVC, feedVC, myVC]
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
        let nav = UINavigationController(rootViewController: viewController)
        nav.tabBarItem = UITabBarItem(
            title: title,
            image: UIImage(named: unselectedImageName, in: .module, compatibleWith: nil)?
                .withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: selectedImageName, in: .module, compatibleWith: nil)?
                .withRenderingMode(.alwaysOriginal)
        )
        return nav
    }
    
    // MARK: - UITabBarControllerDelegate
    
    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if selectedIndex == 2,
           let nav = viewController as? UINavigationController,
           let feedVC = nav.viewControllers.first as? FeedViewController {

            if tabBarController.selectedViewController == viewController {
                feedVC.resetScrollPosition()
            }
        }
    }
}
