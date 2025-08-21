//
//  RecommendFeedViewController.swift
//  HilingualPresentation
//
//  Created by 조영서 on 8/19/25.
//


import UIKit
import Foundation

public final class RecommendFeedViewController: BaseUIViewController<RecommendFeedViewModel> {

    private let feedCellView = FeedCellView()
    private let input = RecommendFeedViewModel.Input()

    public override func loadView() {
        self.view = feedCellView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        input.reload.send(())
    }

    private func bindViewModel() {
        let output = viewModel?.transform(input: input)
        
        output?.feeds
            .receive(on: RunLoop.main)
            .sink { [weak self] feeds in
                self?.feedCellView.apply(items: feeds)
            }
            .store(in: &cancellables)
    }
}
