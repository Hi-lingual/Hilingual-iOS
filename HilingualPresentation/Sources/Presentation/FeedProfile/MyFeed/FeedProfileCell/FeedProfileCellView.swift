//
//  FeedProfileCellView.swift
//  HilingualPresentation
//
//  Created by 조영서 on 8/22/25.
//

import UIKit
import SnapKit

final class FeedProfileCellView: BaseUIView {
    
    // MARK: - Properties

    private var items: [FeedProfileDiaryItem] = [] {
        didSet {
            tableView.reloadData()
            updateEmptyState()
        }
    }

    private let tableView = UITableView(frame: .zero, style: .plain)

    private let noFeedView = EmptyView()

    // MARK: - Setup Methods

    override func setUI() {
        addSubviews(tableView, noFeedView)

        tableView.dataSource = self
        tableView.register(FeedDiaryCell.self, forCellReuseIdentifier: FeedDiaryCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 140
        tableView.showsVerticalScrollIndicator = false

        noFeedView.isHidden = true
    }

    override func setLayout() {
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(32)
        }

        noFeedView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(140)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(242)
            $0.height.equalTo(130)
        }
    }
}

// MARK: - Public API

extension FeedProfileCellView {
    func apply(items: [FeedProfileDiaryItem], emptyMessage: String?) {
        self.items = items

        if let emptyMessage = emptyMessage, items.isEmpty {
            noFeedView.configure(message: emptyMessage)
            noFeedView.isHidden = false
        } else {
            noFeedView.isHidden = true
        }
    }
}

// MARK: - UITableViewDataSource

extension FeedProfileCellView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: FeedDiaryCell.reuseIdentifier,
            for: indexPath
        ) as? FeedDiaryCell else {
            return UITableViewCell()
        }

        let item = items[indexPath.row]
        cell.configure(
            nickname: item.nickname,
            profileImageURL: item.profileImg,
            isMine: item.isMine,
            streak: item.streak,
            sharedDateMinutes: item.sharedDateMinutes,
            diaryPreviewText: item.diaryPreviewText,
            diaryImageURL: item.diaryImageUrl,
            isLiked: item.isLiked,
            likeCount: item.likeCount,
            isLast: indexPath.row == items.count - 1
        )

        return cell
    }
}

// MARK: - Private Methods

private extension FeedProfileCellView {
    func updateEmptyState() {
        noFeedView.isHidden = !items.isEmpty
        bringSubviewToFront(noFeedView)
    }
}
