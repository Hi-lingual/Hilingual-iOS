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
    private let dialog = Dialog()
    
    private var pendingDeleteRow: Int?
    
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
        
        addChild(sharedVC)
        userFeedProfileView.feedContainer.addSubview(sharedVC.view)
        sharedVC.view.snp.makeConstraints { $0.edges.equalToSuperview() }
        sharedVC.didMove(toParent: self)
        
        view.addSubview(dialog)
        dialog.isHidden = true
        dialog.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        sharedVC.onHideTapped = { [weak self] row in
            self?.pendingDeleteRow = row
            self?.showHideDialog()
        }
        
        sharedVC.onReportTapped = { [weak self] in
            guard let self,
                  let url = URL(string: "https://hilingual.notion.site/230829677ebf801c965be24b0ef444e9")
            else { return }
            let safariVC = SFSafariViewController(url: url)
            self.present(safariVC, animated: true)
        }
        
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
    
    // MARK: - Dialog 띄우기
    private func showHideDialog() {
        dialog.configure(
            style: .normal,
            title: "영어 일기를 비공개 하시겠어요?",
            content: "비공개로 전환 시,\n해당 일기의 피드 활동 내역은 모두 사라져요.",
            leftButtonTitle: "취소",
            rightButtonTitle: "확인",
            leftAction: { [weak self] in
                self?.dialog.dismiss()
            },
            rightAction: { [weak self] in
                guard let self, let row = self.pendingDeleteRow else { return }
                self.dialog.dismiss()
                self.sharedVC.removeDiary(at: row)
                self.pendingDeleteRow = nil
            }
        )
        dialog.isHidden = false
        dialog.showAnimation()
        view.bringSubviewToFront(dialog)
    }
}
