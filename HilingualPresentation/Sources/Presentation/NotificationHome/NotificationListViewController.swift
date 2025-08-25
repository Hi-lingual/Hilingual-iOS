//
//  NotificationListViewController.swift
//  HilingualPresentation
//
//  Created by 성현주 on 8/26/25.
//

import UIKit
import Combine

public final class NotificationListViewController: BaseUIViewController<NotificationViewModel> {

    // MARK: - Properties

    private let notificationView = NotificationView()
    private let type: NotificationType
    private let fetchTrigger = PassthroughSubject<Void, Never>()

    private var tableView: UITableView {
        return notificationView.tableView
    }

    // MARK: - Init

    public init(viewModel: NotificationViewModel, diContainer: any ViewControllerFactory, type: NotificationType) {
        self.type = type
        super.init(viewModel: viewModel, diContainer: diContainer)
    }

    // MARK: - Lifecycle

    public override func loadView() {
        self.view = notificationView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        bindViewModel()
        fetchTrigger.send(())
    }

    public override func setDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    // MARK: - Bind

    private func bindViewModel() {
        guard let viewModel else { return }

        let input = NotificationViewModel.Input(
            fetchGeneral: type == .feed ? fetchTrigger.eraseToAnyPublisher() : Empty().eraseToAnyPublisher(),
            fetchNotice: type == .notice ? fetchTrigger.eraseToAnyPublisher() : Empty().eraseToAnyPublisher()
        )

        let output = viewModel.transform(input: input)

        switch type {
        case .feed:
            output.generalNotifications
                .receive(on: DispatchQueue.main)
                .sink { [weak self] list in
                    self?.notificationView.notificationListModel = NotificationListModel(type: .feed, items: list)
                }
                .store(in: &cancellables)

        case .notice:
            output.noticeNotifications
                .receive(on: DispatchQueue.main)
                .sink { [weak self] list in
                    self?.notificationView.notificationListModel = NotificationListModel(type: .notice, items: list)
                }
                .store(in: &cancellables)
        }
    }
}

// MARK: - UITableViewDataSource

extension NotificationListViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationView.notificationListModel.items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NotificationCell.identifier,
            for: indexPath
        ) as? NotificationCell else {
            return UITableViewCell()
        }

        let item = notificationView.notificationListModel.items[indexPath.row]
        cell.configure(with: item)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension NotificationListViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 87
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // TODO: handle deeplink or navigation from selected notification
    }
}
