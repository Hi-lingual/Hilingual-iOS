//
//  TabBarViewController.swift
//  HilingualPresentation
//
//  Created by 성현주 on 7/7/25.
//

import UIKit
import SnapKit

public final class TabBarViewController: UIViewController {

    // MARK: - Properties

    private let factory: ViewControllerFactory
    private let customTabBarHeight: CGFloat = 82
    private var childNavigationControllers: [UINavigationController] = []
    private var currentIndex: Int = 0

    public var selectedIndex: Int {
        get { currentIndex }
        set { selectTab(at: newValue) }
    }

    // MARK: - UI

    private let containerView = UIView()

    private let customTabBarView = CustomTabBarView(items: [
        .init(title: "홈", selectedImageName: "ic_home_black_24_ios", unselectedImageName: "ic_home_gray_24_ios"),
        .init(title: "단어장", selectedImageName: "ic_book_black_24_ios", unselectedImageName: "ic_book_gray_24_ios"),
        .init(title: "피드", selectedImageName: "ic_community_black_24_ios", unselectedImageName: "ic_community_gray_24_ios"),
        .init(title: "마이", selectedImageName: "ic_my_black_24_ios", unselectedImageName: "ic_my_gray_24_ios")
    ])

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
        view.backgroundColor = .white
        setupChildViewControllers()
        setupUI()
        setupLayout()
        setupTabBarAction()
        selectTab(at: 0)
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.bringSubviewToFront(customTabBarView)
    }

    // MARK: - Setup

    private func setupChildViewControllers() {
        childNavigationControllers = [
            makeNavigationController(root: factory.makeHomeViewController()),
            makeNavigationController(root: factory.makeWordBookViewController()),
            makeNavigationController(root: factory.makeFeedViewController()),
            makeNavigationController(root: factory.makeMypageViewController())
        ]
    }

    private func makeNavigationController(root: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: root)
        nav.delegate = self
        return nav
    }

    private func setupUI() {
        view.addSubviews(containerView, customTabBarView)
    }

    private func setupLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        customTabBarView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-customTabBarHeight)
        }
    }

    private func setupTabBarAction() {
        customTabBarView.onSelect = { [weak self] index in
            guard let self else { return }

            if self.currentIndex == index {
                self.handleTabReselection(at: index)
                return
            }
            self.selectTab(at: index)
        }
    }

    // MARK: - Tab Selection

    private func selectTab(at index: Int) {
        guard index >= 0, index < childNavigationControllers.count else { return }

        let previousVC = childNavigationControllers[currentIndex]
        let newVC = childNavigationControllers[index]

        previousVC.willMove(toParent: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParent()

        addChild(newVC)
        containerView.addSubview(newVC.view)
        newVC.view.snp.makeConstraints { $0.edges.equalToSuperview() }
        newVC.didMove(toParent: self)
        newVC.additionalSafeAreaInsets.bottom = customTabBarHeight

        currentIndex = index
        customTabBarView.setSelectedIndex(index)
        updateTabBarVisibility(for: newVC)
    }

    private func handleTabReselection(at index: Int) {
        guard index == 2,
              let feedVC = childNavigationControllers[index].viewControllers.first as? FeedViewController else {
            return
        }
        feedVC.handleFeedTabSelected(isReSelected: true)
    }

    // MARK: - TabBar Visibility

    private func updateTabBarVisibility(for navigationController: UINavigationController) {
        let shouldHide = navigationController.topViewController?.hidesBottomBarWhenPushed ?? false
        setTabBarHidden(shouldHide, animated: false)
    }

    private func setTabBarHidden(_ hidden: Bool, animated: Bool) {
        guard customTabBarView.isHidden != hidden else { return }

        let currentNav = childNavigationControllers[currentIndex]
        let newInset: CGFloat = hidden ? 0 : customTabBarHeight
        let tabBarHeight = customTabBarHeight + view.safeAreaInsets.bottom

        if animated {
            if !hidden {
                customTabBarView.isHidden = false
                customTabBarView.transform = CGAffineTransform(translationX: 0, y: tabBarHeight)
            }
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                self.customTabBarView.transform = hidden
                    ? CGAffineTransform(translationX: 0, y: tabBarHeight)
                    : .identity
                currentNav.additionalSafeAreaInsets.bottom = newInset
            } completion: { _ in
                if hidden {
                    self.customTabBarView.isHidden = true
                }
            }
        } else {
            customTabBarView.isHidden = hidden
            customTabBarView.transform = hidden
                ? CGAffineTransform(translationX: 0, y: tabBarHeight)
                : .identity
            currentNav.additionalSafeAreaInsets.bottom = newInset
        }
    }
}

// MARK: - UINavigationControllerDelegate

extension TabBarViewController: UINavigationControllerDelegate {

    public func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        let shouldHide = viewController.hidesBottomBarWhenPushed
        setTabBarHidden(shouldHide, animated: animated)
    }
}

// MARK: - UIViewController Extension

public extension UIViewController {

    var customTabBarController: TabBarViewController? {
        var current: UIViewController? = self
        while let vc = current {
            if let tabBar = vc as? TabBarViewController {
                return tabBar
            }
            current = vc.parent
        }
        return nil
    }
}
