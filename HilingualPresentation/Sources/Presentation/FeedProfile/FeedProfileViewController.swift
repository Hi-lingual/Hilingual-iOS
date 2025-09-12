//
//  FeedProfileListViewController.swift
//  HilingualPresentation
//
//  Created by 조영서 on 8/25/25.
//

import UIKit
import Foundation
import Combine
import SafariServices

public enum FeedProfileListType {
    case liked
    case shared

    public var emptyMessage: String {
        switch self {
        case .liked:  return "아직 공감한 일기가 없어요."
        case .shared: return "아직 공유한 일기가 없어요."
        }
    }
}

public final class FeedProfileViewController: BaseUIViewController<FeedProfileViewModel> {
    
    // MARK: - Properties
    
    private let feedCellView = FeedList()
    private let input = FeedProfileViewModel.Input()
    private let type: FeedProfileListType
    
    private(set) var currentFeeds: [FeedModel] = []
    private var isFooterApplied = false
    
    var onHideTapped: ((Int) -> Void)?
    var onReportTapped: (() -> Void)?
    var onLikeTapped: ((Int, Bool) -> Void)?
    public var onScroll: ((CGFloat) -> Void)?
    
    // MARK: - Init
    
    public init(viewModel: FeedProfileViewModel,
                diContainer: any ViewControllerFactory,
                type: FeedProfileListType) {
        self.type = type
        super.init(viewModel: viewModel, diContainer: diContainer)
    }
    
    // MARK: - Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        input.reload.send(())
        
        view.addSubview(feedCellView)
        feedCellView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didTopScrollRefresh), for: .valueChanged)
        
        feedCellView.tableView.refreshControl = refreshControl
        feedCellView.tableView.delegate = self
        feedCellView.tableView.dataSource = feedCellView
        feedCellView.tableView.alwaysBounceVertical = false
        
        feedCellView.addTableTapGesture(target: self, action: #selector(didTapTableView))
        
        feedCellView.onHideTapped = { [weak self] row in
            self?.onHideTapped?(row)
        }
        
        feedCellView.onReportTapped = { [weak self] in
            self?.onReportTapped?()
        }
        
        feedCellView.onProfileTapped = { [weak self] row in
            guard let self else { return }
            let user = self.currentFeeds[row]
            
            let targetId = self.viewModel?.targetUserId ?? 0
            
            if user.isMine || Int64(user.userID) == targetId {
                return
            }
            
            let vc = self.diContainer.makeUserFeedProfileViewController(userId: Int64(user.userID))
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }

        feedCellView.onFeedTextTapped = { [weak self] row in
            guard let self else { return }
            let feed = self.currentFeeds[row]
            let vc = self.diContainer.makeSharedDiaryViewController(diaryId: feed.diaryID)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        feedCellView.onFeedImageTapped = { [weak self] row in
            guard let self else { return }
            let feed = self.currentFeeds[row]
            let vc = self.diContainer.makeSharedDiaryViewController(diaryId: feed.diaryID)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }

        feedCellView.onDetailTapped = { [weak self] row in
            guard let self else { return }
            let feed = self.currentFeeds[row]
            let vc = self.diContainer.makeSharedDiaryViewController(diaryId: feed.diaryID)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - Bind
    
    private func bindViewModel() {
        let output = viewModel?.transform(input: input)
        
        output?.feeds
            .receive(on: RunLoop.main)
            .sink { [weak self] feeds in
                guard let self else { return }
                self.currentFeeds = feeds
                self.feedCellView.apply(
                    items: feeds,
                    emptyMessage: type.emptyMessage,
                    type: type
                )
                
                for (index, cell) in self.feedCellView.tableView.visibleCells.enumerated() {
                    if let feedCell = cell as? FeedCell {
                        feedCell.onLikeToggled = { [weak self] isLiked in
                            guard let self else { return }
                            let diaryId = self.currentFeeds[index].diaryID
                            self.onLikeTapped?(diaryId, isLiked)
                        }
                    }
                }

                DispatchQueue.main.async {
                    self.footerForStickyHeader()
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Public Methods
    
    public func removeDiary(at row: Int) {
        guard row < currentFeeds.count else { return }
        currentFeeds.remove(at: row)
        feedCellView.apply(
            items: currentFeeds,
            emptyMessage: type.emptyMessage,
            type: type
        )
        
        DispatchQueue.main.async {
            self.footerForStickyHeader()
        }
    }
    
    public func resetScrollPosition() {
        let tableView = feedCellView.tableView
        tableView.setContentOffset(.zero, animated: false)
        onScroll?(0)
    }
    
    public func refresh() {
        input.reload.send(())
    }
    
    // MARK: - Actions
    
    @objc private func didTapTableView() {
        feedCellView.closeAllMenus()
    }
    
    @objc private func didTopScrollRefresh() {
        self.input.reload.send(())
        feedCellView.tableView.refreshControl?.endRefreshing()
    }
    
    // MARK: - Private Method
    
    private func footerForStickyHeader() {
        guard !isFooterApplied else { return }
        
        let tableView = feedCellView.tableView
        tableView.layoutIfNeeded()
        let contentHeight = tableView.contentSize.height
        
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows.first
        else { return }
        
        let screenHeight = UIScreen.main.bounds.height
        let topInset = window.safeAreaInsets.top
        let bottomInset = window.safeAreaInsets.bottom
        let fixedSafeAreaHeight = screenHeight - topInset - bottomInset
                
        if contentHeight > fixedSafeAreaHeight - 100 {
            tableView.tableFooterView = nil
        }
        else if contentHeight > fixedSafeAreaHeight - 195 {
            let footer = UIView()
            footer.backgroundColor = .red
            footer.frame.size.height = 110
            tableView.tableFooterView = footer
        }
        else {
            tableView.tableFooterView = nil
        }
        isFooterApplied = true
    }
}

// MARK: - UITableViewDelegate

extension FeedProfileViewController: UITableViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let adjustedOffset = scrollView.contentOffset.y + scrollView.adjustedContentInset.top
        onScroll?(adjustedOffset)
    }
}
