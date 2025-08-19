//
//  FeedViewController.swift
//  HilingualPresentation
//
//  Created by 조영서 on 8/18/25.
//

import UIKit
import Foundation

public final class FeedViewController: BaseUIViewController<FeedViewModel> {

    // MARK: - Properties

    private let feedView = FeedView()

    private lazy var loginVC = diContainer.makeLoginViewController()
    private lazy var onboardingVC = diContainer.makeOnboardingViewController()

    // MARK: - Lifecycle

    public override func loadView() {
        self.view = feedView
    }

    public override func setUI() {
        super.setUI()
        feedView.configureSegmentedControl(
            parentVC: self,
            viewControllers: [loginVC, onboardingVC],
            titles: ["Login", "Onboarding"]
        )
    }

    public override func setLayout() {
        super.setLayout()
        // 추가 layout 설정 시 여기에 작성
    }

    public override func addTarget() {
        super.addTarget()
    }

    public override func setDelegate() {
        super.setDelegate()
    }
}

