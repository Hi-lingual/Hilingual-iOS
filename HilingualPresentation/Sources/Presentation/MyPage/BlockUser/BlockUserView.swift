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

    private let emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "img_search_ios", in: .module, compatibleWith: nil)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "차단된 계정이 없어요."
        label.font = .pretendard(.head_r_18)
        label.textColor = .gray500
        label.textAlignment = .center
        return label
    }()

    private lazy var emptyStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [emptyImageView, messageLabel])
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        stack.isHidden = true
        return stack
    }()

    // MARK: - UI Setup

    override func setUI() {
        addSubviews(tableView, emptyStackView)
        tableView.refreshControl = refreshControl
    }

    override func setLayout() {
        tableView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        emptyStackView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(140)
            $0.centerX.equalToSuperview()
        }

        emptyImageView.snp.makeConstraints {
            $0.width.equalTo(210)
            $0.height.equalTo(140)
        }
    }

    // MARK: - Public Method

    func updateEmptyView(isHidden: Bool) {
        emptyStackView.isHidden = isHidden
    }
}
