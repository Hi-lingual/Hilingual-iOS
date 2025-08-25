//
//  NotificationView.swift
//  HilingualPresentation
//
//  Created by 성현주 on 8/26/25.
//

import UIKit

final class NotificationView: BaseUIView {

    // MARK: - Properties

    var notificationListModel: NotificationListModel = NotificationListModel(type: .feed, items: []) {
        didSet {
            updateView()
        }
    }

    // MARK: - UI Components

    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.separatorStyle = .none
        table.backgroundColor = .white
        table.register(NotificationCell.self, forCellReuseIdentifier: NotificationCell.identifier)
        return table
    }()

    private let emptyView = EmptyView()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
        updateView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    override func setUI() {
        addSubviews(tableView, emptyView)
    }

    override func setLayout() {
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        emptyView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    // MARK: - Private

    private func updateView() {
        let items = notificationListModel.items
        let message = notificationListModel.type == .feed ? "피드 알림이 없어요" : "공지사항이 없어요"
        emptyView.configure(message: message)

        tableView.isHidden = items.isEmpty
        emptyView.isHidden = !items.isEmpty
        tableView.reloadData()
    }
}
