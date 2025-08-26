//
//  FeedCellView.swift
//  HilingualPresentation
//
//  Created by 조영서 on 8/19/25.
//

import UIKit
import SnapKit

final class FeedCellView: BaseUIView {
    
    // MARK: - Callbacks
    var onHideTapped: (() -> Void)?
    var onReportTapped: (() -> Void)?
    
    // MARK: - Properties
    private var items: [FeedDiaryItem] = [] {
        didSet {
            tableView.reloadData()
            updateEmptyState()
        }
    }

    private(set) var tableView = UITableView(frame: .zero, style: .plain)
    private let noFeedView = EmptyView()
    private let toast = ToastMessage()

    // MARK: - Setup Methods
    override func setUI() {
        addSubviews(tableView, noFeedView, toast)

        tableView.dataSource = self
        tableView.register(
            FeedDiaryCell.self,
            forCellReuseIdentifier: FeedDiaryCell.reuseIdentifier
        )
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 140
        tableView.showsVerticalScrollIndicator = false
        tableView.refreshControl = UIRefreshControl()

        noFeedView.isHidden = true
        toast.isHidden = true
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
extension FeedCellView {
    func apply(items: [FeedDiaryItem], followingState haveFollowing: Bool? = nil) {
        self.items = items
        
        if items.isEmpty {
            if let haveFollowing = haveFollowing {
                if haveFollowing {
                    noFeedView.configure(message: "피드에 아직 공유된 일기가 없어요.")
                } else {
                    noFeedView.configure(
                        message: "아직 팔로잉한 유저가 없어요.\n마음에 드는 사람을 찾아 팔로우해 보세요!"
                    )
                }
            } else {
                noFeedView.configure(message: "피드에 아직 공유된 일기가 없어요.")
            }
            noFeedView.isHidden = false
        } else {
            noFeedView.isHidden = true
        }
    }
    
    func apply(items: [FeedDiaryItem], emptyMessage: String?) {
        self.items = items
        if let emptyMessage, items.isEmpty {
            noFeedView.configure(message: emptyMessage)
            noFeedView.isHidden = false
        } else {
            noFeedView.isHidden = true
        }
    }
    
    func showToast(message: String) {
        toast.configure(type: .basic, message: message)
        toast.isHidden = false
        toast.alpha = 0
        UIView.animate(withDuration: 0.3) { self.toast.alpha = 1 }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            UIView.animate(withDuration: 0.3, animations: {
                self.toast.alpha = 0
            }, completion: { _ in self.toast.isHidden = true })
        }
    }
}

// MARK: - UITableViewDataSource
extension FeedCellView: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int { items.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
    UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: FeedDiaryCell.reuseIdentifier,
            for: indexPath
        ) as? FeedDiaryCell else {
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
            isLast: indexPath.row == items.count - 1
        )
        return cell
    }
}

// MARK: - Helpers
private extension FeedCellView {
    func updateEmptyState() {
        noFeedView.isHidden = !items.isEmpty
        bringSubviewToFront(noFeedView)
    }
}

// MARK: - Extra
extension FeedCellView {
    func closeAllMenus() {
        for cell in tableView.visibleCells {
            (cell as? FeedDiaryCell)?.closeMenuIfNeeded()
        }
    }
    func addTableTapGesture(target: Any, action: Selector) {
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        tapGesture.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tapGesture)
    }
}

// MARK: - FeedDiaryCellDelegate
extension FeedCellView: FeedDiaryCell.FeedDiaryCellDelegate {
    func feedDiaryCell(_ cell: FeedDiaryCell, didTapMoreButton isMine: Bool) { }
    func feedDiaryCell(_ cell: FeedDiaryCell, didTapMenuItemAt index: Int, isMine: Bool) {
        if isMine {
            onHideTapped?()
        } else {
            onReportTapped?()
        }
    }
}
