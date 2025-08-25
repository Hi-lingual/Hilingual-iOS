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

    private(set) var tableView = UITableView(frame: .zero, style: .plain)
    private let noFeedView = EmptyView()
    private let toast = ToastMessage()

    // MARK: - Setup Methods

    override func setUI() {
        addSubviews(tableView, noFeedView, toast)

        tableView.dataSource = self
        tableView.register(FeedDiaryCell.self, forCellReuseIdentifier: FeedDiaryCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 140
        tableView.showsVerticalScrollIndicator = false
        tableView.refreshControl = UIRefreshControl()

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
        
        toast.isHidden = true
    }
}

// MARK: - Public API

extension FeedCellView {
    
    /// 피드 홈
    func apply(items: [FeedDiaryItem], followingState haveFollowing: Bool? = nil) {
        self.items = items
        
        if items.isEmpty {
            if let haveFollowing = haveFollowing {
                if haveFollowing {
                    noFeedView.configure(message: "피드에 아직 공유된 일기가 없어요.")
                    noFeedView.snp.updateConstraints {
                        $0.top.equalToSuperview().offset(160)
                    }
                } else {
                    noFeedView.configure(message: "아직 팔로잉한 유저가 없어요.\n마음에 드는 사람을 찾아 팔로우해 보세요!")
                    noFeedView.snp.updateConstraints {
                        $0.top.equalToSuperview().offset(160)
                    }
                }
            } else {
                noFeedView.configure(message: "피드에 아직 공유된 일기가 없어요.")
                noFeedView.snp.updateConstraints {
                    $0.top.equalToSuperview().offset(160)
                }
            }
            noFeedView.isHidden = false
        } else {
            noFeedView.isHidden = true
        }
    }
    
    /// 피드 프로필
    func apply(items: [FeedDiaryItem], emptyMessage: String?) {
        self.items = items

        if let emptyMessage = emptyMessage, items.isEmpty {
            noFeedView.configure(message: emptyMessage)
            noFeedView.isHidden = false
        } else {
            noFeedView.isHidden = true
        }
    }
    
    /// 토스트 메세지
    func showToast(message: String) {
        toast.configure(type: .basic, message: message)
        toast.isHidden = false
        toast.alpha = 0
        
        UIView.animate(withDuration: 0.3) {
            self.toast.alpha = 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            UIView.animate(withDuration: 0.3, animations: {
                self.toast.alpha = 0
            }, completion: { _ in
                self.toast.isHidden = true
            })
        }
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

// MARK: - Extension

extension FeedCellView {
    func closeAllMenus() {
        for cell in tableView.visibleCells {
            if let feedCell = cell as? FeedDiaryCell {
                feedCell.closeMenuIfNeeded()
            }
        }
    }
    
    func addTableTapGesture(target: Any, action: Selector) {
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        tapGesture.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tapGesture)
    }
}
