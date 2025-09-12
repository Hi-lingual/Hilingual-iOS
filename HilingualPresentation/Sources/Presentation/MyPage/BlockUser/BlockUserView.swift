//
//  BlockUserView.swift
//  HilingualPresentation
//
//  Created by 성현주 on 8/21/25.
//

import UIKit
import SnapKit

final class BlockUserView: BaseUIView {

    // MARK: - UI Components

    let refreshControl = UIRefreshControl()

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.register(BlockedUserCell.self, forCellReuseIdentifier: "BlockedUserCell")
        return tableView
    }()

    let emptyView: EmptyView = {
        let view = EmptyView()
        view.isHidden = true
        view.configure(message: "차단한 유저가 없어요.", imageName: "img_search_ios")
        return view
    }()

    // MARK: - UI Setup

    override func setUI() {
        addSubviews(tableView,emptyView)
        tableView.refreshControl = refreshControl
    }

    override func setLayout() {
        tableView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

        emptyView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
