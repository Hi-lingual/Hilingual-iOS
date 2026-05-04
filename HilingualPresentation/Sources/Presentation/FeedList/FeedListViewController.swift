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
import HilingualCore

public final class FeedListViewController: BaseUIViewController<FeedViewModel> {

    // MARK: - Properties

    private(set) var feedCellView = FeedListView()
    private let input = FeedViewModel.Input()

    var onHideTapped: ((Int) -> Void)?
    var onReportTapped: (() -> Void)?
    var onRefresh: (() -> Void)?
    var onLikeTapped: ((Int, Bool) -> Void)?

    private(set) var currentFeeds: [FeedModel] = []

    // MARK: - Lifecycle

    public override func loadView() {
        self.view = feedCellView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()

        feedCellView.addTableTapGesture(target: self, action: #selector(didTapTableView))

        feedCellView.onHideTapped = { [weak self] row in
            self?.onHideTapped?(row)
        }

        feedCellView.onReportTapped = { [weak self] in
            self?.onReportTapped?()
        }

        feedCellView.onRefresh = { [weak self] in
            guard let self else { return }

            if let firstFeed = self.currentFeeds.first {
                AmplitudeManager.shared.send(
                    .refreshTriggered(
                        entryId: String(firstFeed.diaryID),
                        method: .auto
                    )
                )
            }

            self.onRefresh?()
        }

        feedCellView.onProfileTapped = { [weak self] row in
            guard let self else { return }
            let user = self.currentFeeds[row]

            if !user.isMine {
                AmplitudeManager.shared.send(
                    .viewProfileUser(
                        profileUserId: String(user.userID),
                        entrySource: .feed,
                        entryId: String(user.diaryID),
                        page: .feed
                    )
                )
            }

            if user.isMine {
                let myVC = self.diContainer.makeMyFeedProfileViewController()
                myVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(myVC, animated: true)
            } else {
                let vc = self.diContainer.makeUserFeedProfileViewController(userId: Int64(user.userID))
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }

        feedCellView.onFeedTextTapped = { [weak self] row in
            guard let self else { return }
            let feed = self.currentFeeds[row]

            AmplitudeManager.shared.send(.pageviewFeed(entryId: String(feed.diaryID)))

            let vc = self.diContainer.makeSharedDiaryViewController(diaryId: feed.diaryID)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }

        feedCellView.onFeedImageTapped = { [weak self] row in
            guard let self else { return }
            let feed = self.currentFeeds[row]

            AmplitudeManager.shared.send(.pageviewFeed(entryId: String(feed.diaryID)))

            let vc = self.diContainer.makeSharedDiaryViewController(diaryId: feed.diaryID)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }

        feedCellView.onDetailTapped = { [weak self] row in
            guard let self else { return }
            let feed = self.currentFeeds[row]

            AmplitudeManager.shared.send(.pageviewFeed(entryId: String(feed.diaryID)))

            let vc = self.diContainer.makeSharedDiaryViewController(diaryId: feed.diaryID)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }

        feedCellView.onLikeTapped = { [weak self] row, isLiked in
            guard let self,
                  row < self.currentFeeds.count else { return }
            let feed = self.currentFeeds[row]

            AmplitudeManager.shared.send(
                .clickEmpathyAction(
                    entryId: String(feed.diaryID),
                    action: isLiked ? .add : .remove
                )
            )

            self.onLikeTapped?(feed.diaryID, isLiked)
        }
    }

    // MARK: - Binding

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

    @objc private func didTopScrollRefresh() {
        if let firstFeed = currentFeeds.first {
            AmplitudeManager.shared.send(
                .refreshTriggered(
                    entryId: String(firstFeed.diaryID),
                    method: .pullToRefresh
                )
            )
        }

        self.input.reload.send(())
        feedCellView.tableView.refreshControl?.endRefreshing()
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

// MARK: - Extension

extension FeedListViewController {
    func resetScrollPosition() {
        let tableView = feedCellView.tableView

        if tableView.numberOfSections > 0,
           tableView.numberOfRows(inSection: 0) > 0 {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0),
                                  at: .top,
                                  animated: true)
        }
    }
}
