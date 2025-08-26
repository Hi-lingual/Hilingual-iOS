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
    
    var onHideTapped: (() -> Void)?
    var onReportTapped: (() -> Void)?

    // MARK: - Lifecycle
    public override func loadView() {
        self.view = feedCellView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        input.reload.send(())
        
        feedCellView.addTableTapGesture(target: self, action: #selector(didTapTableView))
        
        feedCellView.onHideTapped = { [weak self] in
            self?.onHideTapped?()
        }
        
        feedCellView.onReportTapped = { [weak self] in
            self?.onReportTapped?()
        }
    }

    // MARK: - Bindings
    private func bindViewModel() {
        guard let output = viewModel?.transform(input: input) else { return }

        Publishers.CombineLatest(output.feeds, output.haveFollowing)
            .receive(on: RunLoop.main)
            .sink { [weak self] (feeds, haveFollowing) in
                guard let self else { return }
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
}
