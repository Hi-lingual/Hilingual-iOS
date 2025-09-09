//
//  UserFeedProfileViewController.swift
//  HilingualPresentation
//
//  Created by 조영서 on 8/21/25.
//

import UIKit
import Foundation
import SafariServices
import Combine

public final class UserFeedProfileViewController: BaseUIViewController<FeedProfileViewModel> {
        
    // MARK: - Properties
    
    private let input = FeedProfileViewModel.Input()
    private let userFeedProfileView = UserFeedProfileView()
    private let sharedVC: FeedProfileViewController
    private let targetUserId: Int64
    private var isBlocked: Bool = false
    private let dialog = Dialog()
    
    private var pendingDeleteRow: Int?
    
    let unblockTappedSubject = PassthroughSubject<Int64, Never>()
    let blockTappedSubject = PassthroughSubject<Int64, Never>()
    
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
    
    // MARK: - Lifecycle
    
    public override func loadView() {
        self.view = userFeedProfileView
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(sharedVC)
        userFeedProfileView.feedContainer.addSubview(sharedVC.view)
        sharedVC.view.snp.makeConstraints { $0.edges.equalToSuperview() }
        sharedVC.didMove(toParent: self)
        
        sharedVC.onScroll = { [weak self] offsetY in
            guard let self else { return }
            self.userFeedProfileView.updateHeader(offsetY: offsetY)
            self.userFeedProfileView.updateFeedContainer(offsetY: offsetY)
        }
        
        view.addSubview(dialog)
        dialog.isHidden = true
        dialog.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        // 게시글 신고
        sharedVC.onReportTapped = { [weak self] in
            self?.showReportDialog()
        }
        
        // 게시글 공감하기
        sharedVC.onLikeTapped = { [weak self] diaryId, isLiked in
            self?.input.likeTapped.send((diaryId, isLiked))
        }
        
        // 유저 차단 모달 띄우기
        userFeedProfileView.onBlockTapped = { [weak self] in
            self?.userFeedProfileView.dismissModal()
            self?.userFeedProfileView.showBlockDialog()
        }

        // 유저 신고
        userFeedProfileView.onReportTapped = { [weak self] in
            self?.showAccountReportDialog()
        }
        
        // 유저 차단
        userFeedProfileView.onBlockConfirmTapped = { [weak self] in
            guard let self else { return }
            self.userFeedProfileView.dismissBlockDialog()
            self.userFeedProfileView.dismissModal()
            self.userFeedProfileView.showBlockedView()
            
            self.blockTappedSubject.send(self.targetUserId)
            
            self.isBlocked = true
            self.updateNavigation()
        }
        
        // 유저 차단해제
        userFeedProfileView.onUnblockTapped = { [weak self] in
            guard let self else { return }
            self.unblockTappedSubject.send(self.targetUserId)
            self.isBlocked = false
            self.userFeedProfileView.restoreFeedView()
            self.updateNavigation()
        }
        
        // 유저 팔로우 & 팔로우 해제
        userFeedProfileView.onFollowTapped = { [weak self] state in
            guard let self else { return }
            switch state {
            case .follow:
                self.input.follow.send(())
            case .following, .mutualFollow:
                self.input.unfollow.send(())
            default:
                break
            }
        }
        
        userFeedProfileView.setFollowSectionTappedAction { [weak self] in
            self?.pushFollowListViewController()
        }
        
        bind()
    }
    
    // MARK: - Navigation
    
    public override func navigationType() -> NavigationType? {
        return isBlocked ? .backTitle("피드") : .backTitleMenu(title: "피드")
    }
    
    private func updateNavigation() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        setupNavigationBar()

        if case .backTitleMenu = navigationType() {
            navigationItem.rightBarButtonItem?.target = self
            navigationItem.rightBarButtonItem?.action = #selector(menuButtonTapped)
        }
    }
    
    // MARK: - Actions
    
    public override func menuButtonTapped() {
        userFeedProfileView.showModal()
    }
    
    // MARK: - Bind
    
    private func bind() {
        guard let viewModel else { return }
        let output = viewModel.transform(input: self.input)

        blockTappedSubject
            .map { _ in () }
            .subscribe(input.block)
            .store(in: &cancellables)

        unblockTappedSubject
            .map { _ in () }
            .subscribe(input.unblock)
            .store(in: &cancellables)

        output.profile
            .compactMap { $0 }
            .receive(on: RunLoop.main)
            .sink { [weak self] entity in
                self?.userFeedProfileView.configureProfile(
                    nickname: entity.nickname,
                    profileImageURL: entity.profileImg,
                    follower: entity.follower,
                    following: entity.following,
                    streak: entity.streak
                )
            }
            .store(in: &cancellables)

        output.buttonState
            .compactMap { $0 }
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                self?.userFeedProfileView.followButtonState(state)
            }
            .store(in: &cancellables)

        self.input.reload.send(())
    }
        
    // MARK: - Private Methods

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
        
    private func showReportDialog() {
        dialog.configure(
            style: .normal,
            title: "게시글을 신고하시겠어요?",
            content: "신고된 게시글은 확인 후\n서비스의 운영원칙에 따라 처리돼요.",
            leftButtonTitle: "아니요",
            rightButtonTitle: "신고하기",
            leftAction: { [weak self] in
                self?.dialog.dismiss()
            },
            rightAction: { [weak self] in
                self?.dialog.dismiss()
                self?.openReportPage()
            }
        )
        dialog.isHidden = false
        dialog.showAnimation()
        view.bringSubviewToFront(dialog)
    }
    
    private func showAccountReportDialog() {
        userFeedProfileView.dismissModal()

        dialog.configure(
            style: .normal,
            title: "계정을 신고하시겠어요?",
            content: "신고된 계정은 확인 후\n서비스의 운영원칙에 따라 처리돼요.",
            leftButtonTitle: "아니요",
            rightButtonTitle: "신고하기",
            leftAction: { [weak self] in
                self?.dialog.dismiss()
            },
            rightAction: { [weak self] in
                self?.dialog.dismiss()
                self?.openReportPage()
            }
        )
        dialog.isHidden = false
        dialog.showAnimation()
        view.bringSubviewToFront(dialog)
    }

    
    private func openReportPage() {
        guard let url =
                URL(string: "https://hilingual.notion.site/230829677ebf801c965be24b0ef444e9")
        else { return }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
    
    private func pushFollowListViewController() {
        guard let viewModel = self.viewModel else { return }
        
        let followVC = self.diContainer.makeFollowListViewController(targetUserId: Int(viewModel.targetUserId))
        self.navigationController?.pushViewController(followVC, animated: true)
    }
}
