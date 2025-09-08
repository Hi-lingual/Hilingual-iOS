//
//  FeedListViewController.swift
//  HilingualPresentation
//
//  Created by 조영서 on 8/25/25.
//

import UIKit
import Foundation
import Combine
import SafariServices

public final class FeedListViewController: BaseUIViewController<FeedViewModel> {

    // MARK: - Properties
    
    private let feedCellView = FeedList()
    private let input = FeedViewModel.Input()
    
    var onHideTapped: ((Int) -> Void)?
    var onReportTapped: (() -> Void)?
    var onRefresh: (() -> Void)?

    private var currentFeeds: [FeedModel] = []

    // MARK: - Lifecycle
    
    public override func loadView() {
        self.view = feedCellView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        input.reload.send(())
        
        feedCellView.addTableTapGesture(target: self, action: #selector(didTapTableView))
        
        feedCellView.onHideTapped = { [weak self] row in
            self?.onHideTapped?(row)
        }
        
        feedCellView.onReportTapped = { [weak self] in
            self?.onReportTapped?()
        }
        
        feedCellView.onRefresh = { [weak self] in
            guard let self else { return }
//            self.input.reload.send(())
            self.onRefresh?()
        }

        feedCellView.onProfileTapped = { [weak self] row in
            guard let self else { return }
            let user = self.currentFeeds[row]

            if user.isMine == true {
                let myVC = self.diContainer.makeMyFeedProfileViewController()
                myVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(myVC, animated: true)
            } else {
                let vc = self.diContainer.makeUserFeedProfileViewController(userId: Int64(user.userID))
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }

        feedCellView.onDetailTapped = { [weak self] row in
            guard let self else { return }
            let feed = self.currentFeeds[row]
            let vc = self.diContainer.makeSharedDiaryViewController(diaryId: feed.diaryID)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    // MARK: - Bindings
    
    private func bindViewModel() {
        guard let output = viewModel?.transform(input: input) else { return }

        Publishers.CombineLatest(output.feeds, output.haveFollowing)
            .receive(on: RunLoop.main)
            .sink { [weak self] (feeds, haveFollowing) in
                guard let self else { return }
                self.currentFeeds = feeds
                self.feedCellView.apply(
                    items: feeds,
                    followingState: haveFollowing
                )
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    
    @objc private func didTapTableView() {
        feedCellView.closeAllMenus()
    }
    
    // MARK: - Public
    
    func removeDiary(at row: Int) {
        guard row < currentFeeds.count else { return }
        
        currentFeeds.remove(at: row)
        feedCellView.apply(items: currentFeeds)
    }
    
    public func refresh() {
        input.reload.send(())
    }
}
