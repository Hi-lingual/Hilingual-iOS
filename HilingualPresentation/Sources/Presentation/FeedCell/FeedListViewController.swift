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
    private let feedCellView = FeedCellView()
    private let input = FeedViewModel.Input()
    
    var onHideTapped: ((Int) -> Void)?
    var onReportTapped: (() -> Void)?
    var onRefresh: (() -> Void)?

    private var currentFeeds: [FeedDiaryItem] = []

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
            self?.onRefresh?()
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
}
