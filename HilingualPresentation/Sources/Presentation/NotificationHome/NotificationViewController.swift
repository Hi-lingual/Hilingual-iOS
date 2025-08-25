//
//  NotificationViewController.swift
//  HilingualPresentation
//
//  Created by 성현주 on 8/26/25.
//

import UIKit
import Combine

public final class NotificationViewController: BaseUIViewController<NotificationViewModel> {

    // MARK: - Child ViewControllers

    private lazy var feedNotificationVC: NotificationListViewController = {
        guard let viewModel = self.viewModel else {
            fatalError("NotificationViewModel is not initialized")
        }
        return NotificationListViewController(viewModel: viewModel, diContainer: self.diContainer, type: .feed)
    }()

    private lazy var noticeNotificationVC: NotificationListViewController = {
        guard let viewModel = self.viewModel else {
            fatalError("NotificationViewModel is not initialized")
        }
        return NotificationListViewController(viewModel: viewModel, diContainer: self.diContainer, type: .notice)
    }()


    private lazy var segmentedControl = SegmentedControl(
        viewControllers: [feedNotificationVC, noticeNotificationVC],
        titles: ["피드", "공지사항"],
        parentViewController: self
    )


    // MARK: - Init

    public override init(viewModel: NotificationViewModel, diContainer: ViewControllerFactory) {
        super.init(viewModel: viewModel, diContainer: diContainer)
    }

    // MARK: - Life Cycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()

        viewModel?.bind()
        viewModel?.input.fetchGeneral.send(())
        viewModel?.input.fetchNotice.send(())
    }

    // MARK: - Setup

    public override func setUI() {
        view.addSubview(segmentedControl)
    }

    public override func setLayout() {
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    // MARK: - Navigation

    public override func navigationType() -> NavigationType? {
        return .backTitle("알림")
    }

    @objc public override func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
