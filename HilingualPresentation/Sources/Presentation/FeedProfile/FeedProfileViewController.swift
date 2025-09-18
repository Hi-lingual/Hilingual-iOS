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
    
    private(set) var feedCellView = FeedList()
    private let input = FeedProfileViewModel.Input()
    private let type: FeedProfileListType
    
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
        
        view.addSubview(feedCellView)
        feedCellView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didTopScrollRefresh), for: .valueChanged)
        feedCellView.tableView.refreshControl = refreshControl
        
        feedCellView.tableView.delegate = self
        feedCellView.tableView.dataSource = feedCellView
        feedCellView.tableView.alwaysBounceVertical = false
        feedCellView.tableView.bounces = false
        
        feedCellView.addTableTapGesture(target: self, action: #selector(didTapTableView))
        
        feedCellView.onHideTapped = { [weak self] row in
            self?.onHideTapped?(row)
        }
        feedCellView.onReportTapped = { [weak self] in
            self?.onReportTapped?()
        }
        feedCellView.onProfileTapped = { [weak self] row in
            guard let self else { return }
            let user = self.feedCellView.feeds[row]
            
            let targetId = self.viewModel?.targetUserId ?? 0
            if user.isMine || Int64(user.userID) == targetId { return }
            
            let vc = self.diContainer.makeUserFeedProfileViewController(userId: Int64(user.userID))
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        feedCellView.onFeedTextTapped = { [weak self] row in
            guard let self else { return }
            let feed = self.feedCellView.feeds[row]
            let vc = self.diContainer.makeSharedDiaryViewController(diaryId: feed.diaryID)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        feedCellView.onFeedImageTapped = { [weak self] row in
            guard let self else { return }
            let feed = self.feedCellView.feeds[row]
            let vc = self.diContainer.makeSharedDiaryViewController(diaryId: feed.diaryID)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        feedCellView.onDetailTapped = { [weak self] row in
            guard let self else { return }
            let feed = self.feedCellView.feeds[row]
            let vc = self.diContainer.makeSharedDiaryViewController(diaryId: feed.diaryID)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        footerForStickyHeader()
    }
    
    // MARK: - Bind
    
    private func bindViewModel() {
        let output = viewModel?.transform(input: input)
        
        output?.feeds
            .receive(on: RunLoop.main)
            .sink { [weak self] feeds in
                guard let self else { return }
                self.feedCellView.apply(
                    items: feeds,
                    emptyMessage: type.emptyMessage,
                    type: type
                )
                
                self.feedCellView.onLikeTapped = { [weak self] row, isLiked in
                    guard let self = self,
                          row < self.feedCellView.feeds.count else { return }
                    let diaryId = self.feedCellView.feeds[row].diaryID
                    self.onLikeTapped?(diaryId, isLiked)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Public Methods
    
    public func removeDiary(at row: Int) {
        feedCellView.removeDiary(at: row)
    }
    
    public func resetScrollPosition() {
        let tableView = feedCellView.tableView
        tableView.setContentOffset(.zero, animated: true)
        onScroll?(0)
    }
    
    public func refresh() {
        input.reloadFeeds.send(())
    }
    
    // MARK: - Actions
    
    @objc private func didTapTableView() {
        feedCellView.closeAllMenus()
    }
    
    @objc private func didTopScrollRefresh() {
        self.input.reloadFeeds.send(())
        feedCellView.tableView.refreshControl?.endRefreshing()
    }
    
    // MARK: - Private Method
    
    private func footerForStickyHeader() {
        
        let tableView = feedCellView.tableView
        tableView.layoutIfNeeded()
        
        let contentHeightWithoutFooter =
        tableView.contentSize.height - (tableView.tableFooterView?.frame.height ?? 0)
        
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows.first
        else { return }
        
        let screenHeight = UIScreen.main.bounds.height
        let topInset = window.safeAreaInsets.top
        let bottomInset = window.safeAreaInsets.bottom
        let fixedSafeAreaHeight = screenHeight - topInset - bottomInset
        
        if contentHeightWithoutFooter > fixedSafeAreaHeight - 100 {
            tableView.tableFooterView = nil
        }
        else if contentHeightWithoutFooter > fixedSafeAreaHeight - 195 {
            let footer = UIView()
            footer.frame.size.height = 120
            tableView.tableFooterView = footer
        }
        else {
            tableView.tableFooterView = nil
        }
    }
}

// MARK: - UITableViewDelegate

extension FeedProfileViewController: UITableViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let adjustedOffset = scrollView.contentOffset.y + scrollView.adjustedContentInset.top
        onScroll?(adjustedOffset)
    }
}
