//
//  FeedCellView.swift
//  HilingualPresentation
//
//  Created by 조영서 on 8/19/25.
//


import UIKit
import SnapKit

final class FeedCellView: BaseUIView {
    
    // MARK: - Properties

    private var items: [FeedDiaryItem] = [] {
        didSet {
            tableView.reloadData()
            updateEmptyState()
        }
    }

    private let tableView = UITableView(frame: .zero, style: .plain)

    private let noFeedView = NoFeedView()

    // MARK: - Setup Methods

    override func setUI() {
        addSubview(tableView)
        addSubview(noFeedView)

        tableView.dataSource = self
        tableView.register(FeedDiaryCell.self, forCellReuseIdentifier: FeedDiaryCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 140
        tableView.showsVerticalScrollIndicator = false

        noFeedView.configure(message: "아직 좋아요한 다이어리가 없어요.")
        noFeedView.isHidden = true
    }

    override func setLayout() {
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(32)
        }

        noFeedView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(160)
            $0.horizontalEdges.equalToSuperview().inset(66.5)
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}

// MARK: - Public API

extension FeedCellView {
    func apply(items: [FeedDiaryItem]) {
        self.items = items
    }
}

// MARK: - UITableViewDataSource

extension FeedCellView: UITableViewDataSource {

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

private extension FeedCellView {
    func updateEmptyState() {
        noFeedView.isHidden = !items.isEmpty
        bringSubviewToFront(noFeedView)
    }
}
