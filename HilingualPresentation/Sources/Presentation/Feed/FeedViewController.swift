//
//  FeedViewController.swift
//  HilingualPresentation
//
//  Created by 조영서 on 8/18/25.
//

import UIKit
import Foundation
import SafariServices

public final class FeedViewController: BaseUIViewController<FeedViewModel> {
    
    var onLikeTapped: ((Int, Bool) -> Void)?

    // MARK: - Properties
    
    private let input = FeedViewModel.Input()
    private let feedView = FeedView()
    private let dialog = Dialog()

    private lazy var recommendFeedVC: FeedListViewController = {
        let vc = diContainer.makeFeedListViewController(type: .recommended)
        vc.onHideTapped = { [weak self] row in
            self?.showHideDialog(listVC: vc, row: row)
        }
        vc.onReportTapped = { [weak self] in
            self?.showReportDialog()
        }
        vc.onRefresh = { [weak self] in
            self?.showToast(message: "피드의 일기를 모두 확인했어요.")
        }
        vc.onLikeTapped = { [weak self] diaryId, isLiked in
            self?.input.likeTapped.send((diaryId, isLiked))
        }
        return vc
    }()

    private lazy var followingFeedVC: FeedListViewController = {
        let vc = diContainer.makeFeedListViewController(type: .following)
        vc.onHideTapped = { [weak self] row in
            self?.showHideDialog(listVC: vc, row: row)
        }
        vc.onReportTapped = { [weak self] in
            self?.showReportDialog()
        }
        vc.onRefresh = { [weak self] in
            self?.showToast(message: "피드의 일기를 모두 확인했어요.")
        }
        vc.onLikeTapped = { [weak self] diaryId, isLiked in
            self?.input.likeTapped.send((diaryId, isLiked))
        }
        return vc
    }()

    // MARK: - Lifecycle
    
    public override func setUI() {
        feedView.configureSegmentedControl(
            parentVC: self,
            viewControllers: [recommendFeedVC, followingFeedVC],
            titles: ["추천", "팔로잉"]
        )
    }
    
    public override func loadView() {
        self.view = feedView
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        input.reload.send()
        resetScrollPosition()

        recommendFeedVC.refresh()
        followingFeedVC.refresh()
    }
    
    // MARK: - Binding
    
    public override func bind(viewModel: FeedViewModel) {
        let output = viewModel.transform(input: input)
        
        
        output.userProfileImage
            .receive(on: RunLoop.main)
            .sink { [weak self] url in
                self?.feedView.updateProfileImage(url)
            }
            .store(in: &viewModel.cancellables)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        recommendFeedVC.refresh()
        followingFeedVC.refresh()
    }

    //MARK: - Action

    public override func addTarget() {
        feedView.searchButton.addTarget(self, action: #selector(didTapSearch), for: .touchUpInside)
        
        feedView.onProfileTapped = { [weak self] in
            self?.navigateToMyProfile()
        }
        
        feedView.onSegmentChanged = { [weak self] index in
            guard let self else { return }
            if index == 0 {
                self.recommendFeedVC.refresh()
            } else {
                self.followingFeedVC.refresh()
            }
        }
    }

    @objc private func didTapSearch() {
        let feedSearchVC = self.diContainer.makeFeedSearchViewController()
        feedSearchVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(feedSearchVC, animated: true)
    }

    private func navigateToMyProfile() {
        let myProfileVC = diContainer.makeMyFeedProfileViewController()
        myProfileVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(myProfileVC, animated: true)
    }

    // MARK: - Public Methods
    
    func showToast(message: String) {
        feedView.showToast(message: message)
    }

    func showHideDialog(listVC: FeedListViewController, row: Int) {
        guard let containerView = self.tabBarController?.view else { return }
        
        containerView.addSubview(dialog)
        dialog.snp.remakeConstraints { $0.edges.equalTo(containerView) }
        
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
                guard let self else { return }
                self.dialog.dismiss()
                let diaryId = listVC.currentFeeds[row].diaryID
                listVC.removeDiary(at: row)
                self.input.unpublish.send(diaryId)
            }
        )
        dialog.isHidden = false
        dialog.showAnimation()
        containerView.bringSubviewToFront(dialog)
    }

    private func showReportDialog() {
        guard let containerView = self.tabBarController?.view else { return }
        
        containerView.addSubview(dialog)
        dialog.snp.remakeConstraints { $0.edges.equalTo(containerView) }
        
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
        containerView.bringSubviewToFront(dialog)
    }

    private func openReportPage() {
        guard let url =
                URL(string: "https://hilingual.notion.site/230829677ebf801c965be24b0ef444e9")
        else { return }
        let safariVC = SFSafariViewController(url: url)
        self.present(safariVC, animated: true)
    }
}

// MARK: - Extension
extension FeedViewController {
    func resetScrollPosition() {
        recommendFeedVC.resetScrollPosition()
        followingFeedVC.resetScrollPosition()
    }
}
