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

    // MARK: - Properties
    private let feedView = FeedView()
    private let dialog = Dialog()

    private lazy var recommendFeedVC: FeedListViewController = {
        let vc = diContainer.makeFeedListViewController(type: .recommended)
        vc.onHideTapped = { [weak self] row in
            self?.showHideDialog(
                listVC: vc,
                row: row,
                title: "영어 일기를 비공개 하시겠어요?",
                content: "비공개로 전환 시,\n해당 일기의 피드 활동 내역은 모두 사라져요."
            )
        }
        vc.onReportTapped = { [weak self] in
            self?.openReportPage()
        }
        vc.onRefresh = { [weak self] in
            self?.showToast(message: "피드의 일기를 모두 확인했어요.")
        }
        return vc
    }()

    private lazy var followingFeedVC: FeedListViewController = {
        let vc = diContainer.makeFeedListViewController(type: .following)
        vc.onHideTapped = { [weak self] row in
            self?.showHideDialog(
                listVC: vc,
                row: row,
                title: "영어 일기를 비공개 하시겠어요?",
                content: "비공개로 전환 시,\n해당 일기의 피드 활동 내역은 모두 사라져요."
            )
        }
        vc.onReportTapped = { [weak self] in
            self?.openReportPage()
        }
        vc.onRefresh = { [weak self] in
            self?.showToast(message: "피드의 일기를 모두 확인했어요.")
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

        view.addSubview(dialog)
        dialog.isHidden = true
        dialog.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    public override func loadView() {
        self.view = feedView
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Public
    func showToast(message: String) {
        feedView.showToast(message: message)
    }

    func showHideDialog(listVC: FeedListViewController, row: Int, title: String, content: String) {
        dialog.configure(
            style: .normal,
            title: title,
            content: content,
            leftButtonTitle: "취소",
            rightButtonTitle: "확인",
            leftAction: { [weak self] in
                self?.dialog.dismiss()
            },
            rightAction: { [weak self] in
                self?.dialog.dismiss()
                listVC.removeDiary(at: row)
            }
        )
        dialog.isHidden = false
        dialog.showAnimation()
        view.bringSubviewToFront(dialog)
    }

    private func openReportPage() {
        guard let url = URL(string: "https://hilingual.notion.site/230829677ebf801c965be24b0ef444e9") else { return }
        let safariVC = SFSafariViewController(url: url)
        self.present(safariVC, animated: true)
    }
}
