//
//  SegmentedControl.swift
//  HilingualPresentation
//
//  Created by 진소은 on 7/11/25.
//

import UIKit
import SnapKit

// MARK: - SegmentedControl

final class SegmentedControl: UIView {
    // MARK: - UI Components

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
        }
    }

    // MARK: - Initializer

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

        SetUI()
        setLayout()
        configurePageViewController()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func SetUI() {
        addSubview(segmentedControl)
        addSubview(pageViewController.view)

        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedValueChanged(_:)), for: .valueChanged)
    }

    private func setLayout() {
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

    // MARK: - Action

    @objc private func segmentedValueChanged(_ sender: UISegmentedControl) {
        currentPage = sender.selectedSegmentIndex
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
        segmentedControl.selectedSegmentIndex = index
    }
}

// MARK: - UnderlineSegmentedControl

final class UnderlineSegmentedControl: UISegmentedControl {
    private let underlineView = UIView()

    override init(items: [Any]?) {
        super.init(items: items)
        setStyle()
        setUnderline()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setStyle() {
        let image = UIImage()
        setBackgroundImage(image, for: .normal, barMetrics: .default)
        setDividerImage(image, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        tintColor = .clear
        
        setTitleTextAttributes([
            .foregroundColor: UIColor.black,
            .font: UIFont.suit(.head_b_18)
        ], for: .normal)
    }

    private func setUnderline() {
        underlineView.backgroundColor = .black
        underlineView.layer.cornerRadius = 1
        underlineView.clipsToBounds = true
        
        addSubview(underlineView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let segmentWidth = bounds.width / CGFloat(numberOfSegments)
        let xPosition = CGFloat(selectedSegmentIndex) * segmentWidth

        underlineView.frame = CGRect(
            x: xPosition + 4,
            y: bounds.height - 3,
            width: segmentWidth - 8,
            height: 3,
        )
    }
}
