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

public final class FeedProfileListViewController: BaseUIViewController<FeedProfileViewModel> {
    
    // MARK: - Properties
    private let feedCellView = FeedCellView()
    private let input = FeedProfileViewModel.Input()
    private let type: FeedProfileListType

    // MARK: - Init
    public init(viewModel: FeedProfileViewModel,
                diContainer: any ViewControllerFactory,
                type: FeedProfileListType) {
        self.type = type
        super.init(viewModel: viewModel, diContainer: diContainer)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Lifecycle
    public override func loadView() {
        self.view = feedCellView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        input.reload.send(())
        
        feedCellView.addTableTapGesture(target: self, action: #selector(didTapTableView))
        
        feedCellView.onReportTapped = { [weak self] in
            guard let self,
                  let url =
                    URL(string: "https://hilingual.notion.site/230829677ebf801c965be24b0ef444e9")
            else { return }
            let safariVC = SFSafariViewController(url: url)
            self.present(safariVC, animated: true)
        }
    }

    // MARK: - Bindings
    private func bindViewModel() {
        let output = viewModel?.transform(input: input)

        output?.feeds
            .receive(on: RunLoop.main)
            .sink { [weak self] feeds in
                guard let self else { return }
                self.feedCellView.apply(
                    items: feeds,
                    emptyMessage: type.emptyMessage
                )
            }
            .store(in: &cancellables)
    }
    
    @objc private func didTapTableView() {
        feedCellView.closeAllMenus()
    }
}
