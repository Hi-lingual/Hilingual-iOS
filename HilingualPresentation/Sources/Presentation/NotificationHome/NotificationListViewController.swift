//
//  NotificationListViewController.swift
//  HilingualPresentation
//
//  Created by 성현주 on 8/26/25.
//

import UIKit
import Combine
import HilingualCore

public final class NotificationListViewController: BaseUIViewController<NotificationViewModel> {

    // MARK: - Properties

    private let notificationView = NotificationView()
    private let type: NotificationType
    private let fetchTrigger = PassthroughSubject<Void, Never>()
    private let markAsReadTrigger = PassthroughSubject<Int, Never>()

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
        setupRefreshControl()
        fetchTrigger.send(())
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTrigger.send(())
    }

    public override func setDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = .gray200
    }

    // MARK: - Bind

    public override func bind(viewModel: NotificationViewModel) {
        super.bind(viewModel: viewModel)

        let input = NotificationViewModel.Input(
            fetchGeneral: {
                if case .feed = type { return fetchTrigger.eraseToAnyPublisher() }
                return Empty().eraseToAnyPublisher()
            }(),
            fetchNotice: {
                if case .notice = type { return fetchTrigger.eraseToAnyPublisher() }
                return Empty().eraseToAnyPublisher()
            }(),
            markAsRead: markAsReadTrigger.eraseToAnyPublisher()
        )

        let output = viewModel.transform(input: input)

        switch type {
        case .feed(let raw):
            output.generalNotifications
                .receive(on: DispatchQueue.main)
                .sink { [weak self] list in
                    self?.notificationView.notificationListModel = NotificationListModel(
                        type: .feed(raw),
                        items: list
                    )
                    self?.notificationView.refreshControl.endRefreshing()
                }
                .store(in: &cancellables)

        case .notice(let raw):
            output.noticeNotifications
                .receive(on: DispatchQueue.main)
                .sink { [weak self] list in
                    self?.notificationView.notificationListModel = NotificationListModel(
                        type: .notice(raw),
                        items: list
                    )
                    self?.notificationView.refreshControl.endRefreshing()
                }
                .store(in: &cancellables)
        }
    }

    //MARK: - Private Method

    private func setupRefreshControl() {
        notificationView.refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }

    @objc private func handleRefresh() {
        fetchTrigger.send(())
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

        let selectedItem = notificationView.notificationListModel.items[indexPath.row]

        if selectedItem.isRead == false {
            markAsReadTrigger.send(selectedItem.id)
        }

        switch selectedItem.type {
        case .feed(let rawType):
            switch rawType {
            case "LIKE_DIARY":
                guard let diaryId = selectedItem.targetId else {return}

                AmplitudeManager.shared.send(
                    .viewProfileUser(
                        profileUserId: String(selectedItem.targetId ?? 0),
                        entrySource: .notification,
                        entryId: String(diaryId),
                        page: .notification
                    )
                )

                AmplitudeManager.shared.send(.pageviewPostedDiary(entryId: String(diaryId)))

                let vc = self.diContainer.makeSharedDiaryViewController(diaryId: diaryId)
                navigationController?.pushViewController(vc, animated: true)

            case "FOLLOW_USER":
                guard let userId = selectedItem.targetId else {return}

                AmplitudeManager.shared.send(
                    .viewProfileUser(
                        profileUserId: String(userId),
                        entrySource: .notification,
                        entryId: String(selectedItem.id),
                        page: .notification
                    )
                )

                let vc = self.diContainer.makeUserFeedProfileViewController(userId: Int64(userId))
                navigationController?.pushViewController(vc, animated: true)

            default:
                print("알 수 없는 feed 타입: \(rawType)")
            }

        case .notice(let rawType):
            let detailVC = self.diContainer.makeNotificationDetailViewController(notiId: selectedItem.id)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
