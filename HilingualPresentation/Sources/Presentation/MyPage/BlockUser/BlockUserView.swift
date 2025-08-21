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

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .white
        tableView.register(BlockedUserCell.self, forCellReuseIdentifier: "BlockedUserCell")
        tableView.rowHeight = 60
        return tableView
    }()

    // MARK: - UI Setup

    override func setUI() {
        addSubview(tableView)
    }

    override func setLayout() {
        tableView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
