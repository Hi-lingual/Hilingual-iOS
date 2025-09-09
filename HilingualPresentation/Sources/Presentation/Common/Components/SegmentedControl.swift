//
//  SegmentedControl.swift
//  HilingualPresentation
//
//  Created by 진소은 on 7/11/25.
//

import UIKit
import SnapKit

@MainActor
protocol ScrollControllable: AnyObject {
    func scrollToTop()
}

final class SegmentedControl: UIView {
    
    // 외부에 탭 전환 알려주는 콜백
    var onIndexChanged: ((Int) -> Void)?

    private let segmentedControl: UnderlineSegmentedControl
    private let pageViewController: UIPageViewController
    private let viewControllers: [UIViewController]
    private weak var parentViewController: UIViewController?

    private var currentPage: Int = 0 {
        didSet {
            let direction: UIPageViewController.NavigationDirection = oldValue <= currentPage ? .forward : .reverse
            pageViewController.setViewControllers(
                [viewControllers[currentPage]],
                direction: direction,
                animated: true
            )

            if let scrollableVC = viewControllers[currentPage] as? ScrollControllable {
                scrollableVC.scrollToTop()
            }
            
            //탭 전환
            onIndexChanged?(currentPage)
        }
    }

    init(viewControllers: [UIViewController],
         titles: [String],
         parentViewController: UIViewController) {
        self.viewControllers = viewControllers
        self.parentViewController = parentViewController
        self.segmentedControl = UnderlineSegmentedControl(items: titles)
        self.pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )

        super.init(frame: .zero)

        setupUI()
        setupLayout()
        configurePageViewController()
        bindSegmentControl()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(segmentedControl)
        addSubview(pageViewController.view)
    }

    private func setupLayout() {
        segmentedControl.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(48)
        }

        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func configurePageViewController() {
        guard let parentVC = parentViewController else { return }

        pageViewController.setViewControllers([viewControllers[0]], direction: .forward, animated: false)
        pageViewController.delegate = self
        pageViewController.dataSource = self

        parentVC.addChild(pageViewController)
        pageViewController.didMove(toParent: parentVC)
    }

    private func bindSegmentControl() {
        segmentedControl.didSelectIndex = { [weak self] index in
            self?.currentPage = index
        }
    }
}

// MARK: - UIPageViewController Delegate & DataSource

extension SegmentedControl: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(where: { $0 === viewController }), index > 0 else {
            return nil
        }
        return viewControllers[index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(where: { $0 === viewController }),
              index < viewControllers.count - 1 else {
            return nil
        }
        return viewControllers[index + 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard completed,
              let currentVC = pageViewController.viewControllers?.first,
              let index = viewControllers.firstIndex(where: { $0 === currentVC }) else {
            return
        }
        currentPage = index
        segmentedControl.selectedIndex = index
    }
}
