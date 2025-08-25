//
//  UserFeedProfileViewController.swift
//  HilingualPresentation
//
//  Created by 조영서 on 8/21/25.
//

import UIKit
import Foundation
import SafariServices

public final class UserFeedProfileViewController: BaseUIViewController<FeedProfileViewModel> {
    
    // MARK: - Properties
    private let userFeedProfileView = UserFeedProfileView()
    private let sharedVC: FeedProfileListViewController
    private let targetUserId: Int64
    private var isBlocked: Bool = false
    
    // MARK: - Init
    public init(
        viewModel: FeedProfileViewModel,
        diContainer: any ViewControllerFactory,
        targetUserId: Int64
    ) {
        self.targetUserId = targetUserId
        self.sharedVC = diContainer.makeFeedProfileListViewController(
            type: .shared,
            userId: targetUserId
        )
        super.init(viewModel: viewModel, diContainer: diContainer)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Lifecycle
    public override func loadView() {
        self.view = userFeedProfileView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // feedContainer에 VC 붙이기
        addChild(sharedVC)
        userFeedProfileView.feedContainer.addSubview(sharedVC.view)
        sharedVC.view.snp.makeConstraints { $0.edges.equalToSuperview() }
        sharedVC.didMove(toParent: self)
        
        userFeedProfileView.onBlockTapped = { [weak self] in
            self?.userFeedProfileView.showBlockDialog()
        }
        
        userFeedProfileView.onBlockConfirmTapped = { [weak self] in
            guard let self else { return }
            self.userFeedProfileView.dismissBlockDialog()
            self.userFeedProfileView.dismissModal()
            self.userFeedProfileView.showBlockedView()
            self.isBlocked = true
            self.updateNavigation()
        }
        
        userFeedProfileView.onReportTapped = { [weak self] in
            guard let url = URL(string: "https://hilingual.notion.site/230829677ebf801c965be24b0ef444e9"),
                  let self else { return }
            let safariVC = SFSafariViewController(url: url)
            self.present(safariVC, animated: true)
        }
    }
    
    // MARK: - Navigation
    public override func navigationType() -> NavigationType? {
        return isBlocked ? .backOnly : .backTitleMenu("")
    }
    
    private func updateNavigation() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        setupNavigationBar()
    }
    
    // MARK: - Actions
    public override func menuButtonTapped() {
        userFeedProfileView.showModal()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
