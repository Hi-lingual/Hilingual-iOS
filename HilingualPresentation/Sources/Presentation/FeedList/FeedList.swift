//
//  FeedList.swift
//  HilingualPresentation
//
//  Created by 조영서 on 8/19/25.
//

import UIKit
import SnapKit

final class FeedList: BaseUIView {
    
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
        didSet {
            tableView.reloadData()
            updateEmptyState()
        }
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
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleTopRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
                
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 32, right: 0)

        noFeedView.isHidden = true
    }

    override func setLayout() {
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

        noFeedView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(140)
            $0.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Actions
    
    @objc private func handleTopRefresh() {
        tableView.refreshControl?.endRefreshing()
    }
}

// MARK: - Public API

extension FeedList {
    func apply(items: [FeedModel], followingState haveFollowing: Bool? = nil) {
        self.items = items
        
        if items.isEmpty {
            if let haveFollowing = haveFollowing {
                if haveFollowing {
                    noFeedView.configure(message: "피드에 아직 공유된 일기가 없어요.")
                    noFeedView.snp.updateConstraints { $0.top.equalToSuperview().offset(160) }

                } else {
                    noFeedView.configure(
                        message: "아직 팔로잉한 유저가 없어요.\n마음에 드는 사람을 찾아 팔로우해 보세요!"
                    )
                    noFeedView.snp.updateConstraints { $0.top.equalToSuperview().offset(160) }
                }
            } else {
                noFeedView.configure(message: "피드에 아직 공유된 일기가 없어요.")
                noFeedView.snp.updateConstraints { $0.top.equalToSuperview().offset(160) }
            }
            noFeedView.isHidden = false
        } else {
            noFeedView.isHidden = true
        }
    }
    
    func apply(items: [FeedModel], emptyMessage: String?, type: FeedProfileListType) {
        self.items = items
        self.type = type
        if let emptyMessage, items.isEmpty {
            noFeedView.configure(message: emptyMessage)
            noFeedView.isHidden = false
        } else {
            noFeedView.isHidden = true
        }
    }
    
    var feeds: [FeedModel] {
        return items
    }
}

// MARK: - Extensions

extension FeedList: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int { items.count }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: FeedCell.reuseIdentifier,
            for: indexPath
        ) as? FeedCell else {
            return UITableViewCell()
        }
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
}

extension FeedList: UITableViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        if offsetY > contentHeight - frameHeight + 50 {
            onRefresh?()
        }
    }
}

private extension FeedList {
    func updateEmptyState() {
        noFeedView.isHidden = !items.isEmpty
        bringSubviewToFront(noFeedView)
    }
}

extension FeedList {
    func closeAllMenus() {
        for cell in tableView.visibleCells {
            (cell as? FeedCell)?.closeMenuIfNeeded()
        }
    }
    func addTableTapGesture(target: Any, action: Selector) {
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        tapGesture.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tapGesture)
    }
    
    func removeDiary(at row: Int) {
        guard row < items.count else { return }
        items.remove(at: row)
        tableView.deleteRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
    }
}

extension FeedList: FeedCell.FeedCellDelegate {
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
        if isMine {
            if let row = tableView.indexPath(for: cell)?.row {
                onHideTapped?(row)
            }
        } else {
            onReportTapped?()
        }
    }
}
