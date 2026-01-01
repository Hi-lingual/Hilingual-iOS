//
//  FeedListView.swift
//  HilingualPresentation
//
//  Created by 조영서 on 8/19/25.
//

import UIKit
import SnapKit

final class FeedListView: BaseUIView {

    // MARK: - Callbacks

    var onHideTapped: ((Int) -> Void)?
    var onReportTapped: (() -> Void)?
    var onRefresh: (() -> Void)?
    var onProfileTapped: ((Int) -> Void)?
    var onDetailTapped: ((Int) -> Void)?
    var onFeedTextTapped: ((Int) -> Void)?
    var onFeedImageTapped: ((Int) -> Void)?
    var onLikeTapped: ((Int, Bool) -> Void)?

    // MARK: - Properties

    private var items: [FeedModel] = [] {
        didSet { tableView.reloadData() }
    }
    private var type: FeedProfileListType?

    private(set) var tableView = UITableView(frame: .zero, style: .plain)
    private let noFeedView = EmptyView()

    // MARK: - Setup Methods

    override func setUI() {
        addSubviews(tableView, noFeedView)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            FeedCell.self,
            forCellReuseIdentifier: FeedCell.reuseIdentifier
        )

        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 140
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 32, right: 0)

        noFeedView.isHidden = true
    }

    override func setLayout() {
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        noFeedView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(160)
            $0.centerX.equalToSuperview()
        }
    }
}

// MARK: - Extensions

extension FeedListView {

    func apply(items: [FeedModel], followingState haveFollowing: Bool? = nil) {
        self.items = items
        updateEmptyView(followingState: haveFollowing)
    }

    func apply(items: [FeedModel], emptyMessage: String?, type: FeedProfileListType) {
        self.items = items
        self.type = type
        updateEmptyView(customMessage: emptyMessage)
    }

    var feeds: [FeedModel] {
        items
    }

    func closeAllMenus() {
        for cell in tableView.visibleCells {
            if let feedCell = cell as? FeedCell {
                feedCell.closeMenuIfNeeded()
            }
        }
    }

    func addTableTapGesture(target: Any, action: Selector) {
        let tap = UITapGestureRecognizer(target: target, action: action)
        tap.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tap)
    }

    func removeDiary(at row: Int) {
        guard items.indices.contains(row) else { return }
        items.remove(at: row)
        tableView.reloadData()
    }
}

// MARK: - Private Methods

private extension FeedListView {

    func updateEmptyView(
        followingState haveFollowing: Bool? = nil,
        customMessage: String? = nil
    ) {
        guard items.isEmpty else {
            noFeedView.isHidden = true
            return
        }

        let message =
            customMessage ??
            (haveFollowing == false
                ? "아직 팔로잉한 유저가 없어요.\n마음에 드는 사람을 찾아 팔로우해 보세요!"
                : "피드에 아직 공유된 일기가 없어요.")

        noFeedView.configure(message: message)
        noFeedView.isHidden = false
        bringSubviewToFront(noFeedView)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension FeedListView: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: FeedCell.reuseIdentifier,
            for: indexPath
        ) as? FeedCell else { return UITableViewCell() }

        let item = items[indexPath.row]
        cell.delegate = self
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
            isLast: indexPath.row == items.count - 1,
            type: type
        )

        cell.onLikeToggled = { [weak self] isLiked in
            self?.onLikeTapped?(indexPath.row, isLiked)
        }

        return cell
    }

    func scrollViewDidEndDragging(
        _ scrollView: UIScrollView,
        willDecelerate decelerate: Bool
    ) {
        let threshold = scrollView.contentSize.height - scrollView.frame.height + 50
        if scrollView.contentOffset.y > threshold {
            onRefresh?()
        }
    }
}

// MARK: - FeedCellDelegate

extension FeedListView: FeedCell.FeedCellDelegate {

    func feedCellDidTapProfile(_ cell: FeedCell) {
        if let row = tableView.indexPath(for: cell)?.row {
            onProfileTapped?(row)
        }
    }

    func feedCellDidTapDetail(_ cell: FeedCell) {
        if let row = tableView.indexPath(for: cell)?.row {
            onDetailTapped?(row)
        }
    }

    func feedCellDidTapFeedText(_ cell: FeedCell) {
        if let row = tableView.indexPath(for: cell)?.row {
            onFeedTextTapped?(row)
        }
    }

    func feedCellDidTapFeedImage(_ cell: FeedCell) {
        if let row = tableView.indexPath(for: cell)?.row {
            onFeedImageTapped?(row)
        }
    }

    func feedCell(_ cell: FeedCell, didTapMoreButton isMine: Bool) { }

    func feedCell(_ cell: FeedCell, didTapMenuItemAt index: Int, isMine: Bool) {
        if let row = tableView.indexPath(for: cell)?.row {
            isMine ? onHideTapped?(row) : onReportTapped?()
        }
    }
}
