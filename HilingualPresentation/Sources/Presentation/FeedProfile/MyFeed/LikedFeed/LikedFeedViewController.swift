//
//  LikedFeedViewController.swift
//  HilingualPresentation
//
//  Created by 조영서 on 8/22/25.
//

import UIKit
import Foundation

public final class LikedFeedViewController: BaseUIViewController<LikedFeedViewModel> {

    private let feedCellView = FeedProfileCellView()
    private let input = LikedFeedViewModel.Input()

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
                guard let self else { return }
                self.feedCellView.apply(
                    items: feeds,
                    emptyMessage: "아직 공감한 일기가 없어요."
                )
            }
            .store(in: &cancellables)
    }
}
