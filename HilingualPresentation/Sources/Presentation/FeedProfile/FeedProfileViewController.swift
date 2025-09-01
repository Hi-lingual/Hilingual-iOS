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
    
    private var currentFeeds: [FeedModel] = []
    
    var onHideTapped: ((Int) -> Void)?
    var onReportTapped: (() -> Void)?
    
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

        feedCellView.tableView.delegate = self
        feedCellView.tableView.dataSource = feedCellView

        feedCellView.addTableTapGesture(target: self, action: #selector(didTapTableView))

        feedCellView.onHideTapped = { [weak self] row in
            self?.onHideTapped?(row)
        }

        feedCellView.onReportTapped = { [weak self] in
            self?.onReportTapped?()
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
            }
            .store(in: &cancellables)
    }

    // MARK: - Public API
    public func removeDiary(at row: Int) {
        guard row < currentFeeds.count else { return }
        currentFeeds.remove(at: row)
        feedCellView.apply(
            items: currentFeeds,
            emptyMessage: type.emptyMessage,
            type: type
        )
    }

    // MARK: - Actions
    @objc private func didTapTableView() {
        feedCellView.closeAllMenus()
    }
}

// MARK: - UITableViewDelegate
extension FeedProfileViewController: UITableViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let adjustedOffset = scrollView.contentOffset.y + scrollView.adjustedContentInset.top
        onScroll?(adjustedOffset)
    }
}
