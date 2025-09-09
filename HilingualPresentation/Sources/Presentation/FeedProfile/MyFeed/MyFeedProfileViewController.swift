//
//  MyFeedProfileViewController.swift
//  HilingualPresentation
//
//  Created by 조영서 on 8/21/25.
//

import UIKit
import Foundation
import SafariServices
import Combine

public final class MyFeedProfileViewController: BaseUIViewController<FeedProfileViewModel> {

    // MARK: - Properties
    
    private let myFeedProfileView = MyFeedProfileView()
    private let likedVC: FeedProfileViewController
    private let sharedVC: FeedProfileViewController
    private let dialog = Dialog()
    private var pendingDeleteRow: (listVC: FeedProfileViewController, row: Int)?

    // MARK: - Init
    
    public init(
        viewModel: FeedProfileViewModel,
        diContainer: any ViewControllerFactory,
        likedVC: FeedProfileViewController,
        sharedVC: FeedProfileViewController
    ) {
        self.likedVC = likedVC
        self.sharedVC = sharedVC
        super.init(viewModel: viewModel, diContainer: diContainer)
    }

    // MARK: - Lifecycle
    
    public override func loadView() {
        self.view = myFeedProfileView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        myFeedProfileView.configureSegmentedControl(
            parentVC: self,
            viewControllers: [sharedVC, likedVC],
            titles: ["공유한 일기", "공감한 일기"]
        )
        
        view.addSubview(dialog)
        dialog.isHidden = true
        dialog.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        sharedVC.onScroll = { [weak self] offsetY in
            self?.myFeedProfileView.updateHeader(offsetY: offsetY)
        }

        likedVC.onScroll = { [weak self] offsetY in
            self?.myFeedProfileView.updateHeader(offsetY: offsetY)
        }
        
        /// 공유 - 게시글 비공개하기
        sharedVC.onHideTapped = { [weak self] row in
            self?.showHideDialog(listVC: self?.sharedVC, row: row)
        }
        
        /// 공유 - 게시글 신고하기
        sharedVC.onReportTapped = { [weak self] in
            self?.showReportDialog()
        }
        
        /// 공감 - 게시글 비공개하기
        likedVC.onHideTapped = { [weak self] row in
            self?.showHideDialog(listVC: self?.likedVC, row: row)
        }
        
        /// 공감 - 게시글 신고하기
        likedVC.onReportTapped = { [weak self] in
            self?.showReportDialog()
        }

        myFeedProfileView.setFollowSectionTappedAction { [weak self] in
            self?.pushFollowListViewController()
        }

        bind()
    }
    
    public override func navigationType() -> NavigationType? {
        return .backTitle("피드")
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - Bind
    
    private func bind() {
        let input = FeedProfileViewModel.Input()
        guard let viewModel else { return }

        let output = viewModel.transform(input: input)

        output.profile
            .compactMap { $0 }
            .receive(on: RunLoop.main)
            .sink { [weak self] entity in
                self?.myFeedProfileView.configureProfile(
                    nickname: entity.nickname,
                    profileImageURL: entity.profileImg,
                    follower: entity.follower,
                    following: entity.following,
                    streak: entity.streak
                )
            }
            .store(in: &viewModel.cancellables)

        input.reload.send(())
    }

    // MARK: - Private Methods
    
    private func showHideDialog(listVC: FeedProfileViewController?, row: Int) {
        guard let listVC else { return }
        pendingDeleteRow = (listVC, row)
        
        dialog.configure(
            style: .normal,
            title: "영어 일기를 비공개 하시겠어요?",
            content: "비공개로 전환 시,\n해당 일기의 피드 활동 내역은 모두 사라져요.",
            leftButtonTitle: "취소",
            rightButtonTitle: "확인",
            leftAction: { [weak self] in
                self?.dialog.dismiss()
                self?.pendingDeleteRow = nil
            },
            rightAction: { [weak self] in
                guard let self,
                      let (listVC, row) = self.pendingDeleteRow else { return }
                self.dialog.dismiss()
                listVC.removeDiary(at: row)
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
