//
//  SharedDiaryViewController.swift
//  HilingualPresentation
//
//  Created by 진소은 on 8/21/25.
//

import Foundation
import SafariServices
import UIKit

import Combine

public final class SharedDiaryViewController: BaseUIViewController<DiaryDetailViewModel> {
    
    // MARK: - Properties
    
    public var isMine: Bool = true
    
    private let sharedDiaryView = SharedDiaryView()
    private lazy var diaryDetailViewController: DiaryDetailViewController = {
        let vc = diContainer.makeDiaryDetailViewController(diaryId: 1)
        vc.showsActionButton = false
        return vc
    }()
    
    private let bottomSafeAreaBackgroundView = UIView()
    
    private let dialog = Dialog()
    
    private let modal: Modal = {
        let modal = Modal()
        modal.isHidden = true
        return modal
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        addChild(diaryDetailViewController)
        diaryDetailViewController.didMove(toParent: self)
        
        sharedDiaryView.onProfileAction = { [weak self] in
            guard let self else { return }
            let vc = diContainer.makeDiaryDetailViewController(diaryId: 1)
            self.navigationController?.pushViewController(vc, animated: true)
        }

        sharedDiaryView.onLikeAction = { [weak self] isLiked in
            guard let self else { return }
            // 서버에 공감하기 api 호출
        }
    }
    
    public override func setUI() {
        view.addSubviews(bottomSafeAreaBackgroundView, sharedDiaryView, diaryDetailViewController.view, modal, dialog)
        
        modal.isHidden = true
        dialog.isHidden = true
        bottomSafeAreaBackgroundView.backgroundColor = .gray100
        
        view.bringSubviewToFront(modal)
        view.bringSubviewToFront(bottomSafeAreaBackgroundView)
    }
    
    public override func setLayout() {
        sharedDiaryView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(62)
        }
        
        bottomSafeAreaBackgroundView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        diaryDetailViewController.view.snp.makeConstraints {
            $0.top.equalTo(sharedDiaryView.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        modal.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        dialog.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    public override func navigationType() -> NavigationType? {
        return .backTitleMenu("")
    }
    
    @objc public override func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    public override func menuButtonTapped() {
        showModal()
    }
    
    // TODO: - 차단하기 modal 연결
    
    @objc private func showModal() {
            let items: [(String, UIImage?, () -> Void)]

            if isMine {
                    items = [
                        ("비공개하기", UIImage(resource: .icHide24Ios), { [weak self] in
                            guard let self else { return }
                            // TODO: 서버에 비공개 전환 API 호출
                            self.modal.isHidden = true
                            showPrivateDialog()
                        })
                    ]
            } else {
                items = [
                    ("계정 차단하기", UIImage(resource: .icBlockGray24Ios), { [weak self] in
                        self?.modal.isHidden = true
                        // TODO: 서버 차단 API 호출
                    }),
                    ("게시글 신고하기", UIImage(resource: .icReport24Ios), { [weak self] in
                        self?.modal.isHidden = true
                        guard let url = URL(string: "https://hilingual.notion.site/230829677ebf801c965be24b0ef444e9") else { return }
                        let safariVC = SFSafariViewController(url: url)
                        self?.present(safariVC, animated: true)
                    })
                ]
            }

            modal.configure(
                title: nil,
                items: items
            )
            modal.isHidden = false
            DispatchQueue.main.async { [weak self] in
                self?.modal.showAnimation()
            }
        }
    
    @objc private func showPrivateDialog() {
        dialog.configure(
            title: "영어 일기를 비공개 하시겠어요?",
            content: "비공개로 전환 시,\n해당 일기의 피드 활동 내역은 모두 사라져요.",
            leftButtonTitle: "아니요",
            rightButtonTitle: "비공개하기",
            leftAction: { [weak self] in
                self?.dialog.dismiss()
            },
            rightAction: { [weak self] in
                        guard let self else { return }
                        self.dialog.dismiss()
                        
                        // 1) 이전 화면 참조
                        if let nav = self.navigationController {
                            nav.popViewController(animated: true)
                            
                            // 2) pop 완료 후 토스트 띄우기
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                if let previousVC = nav.viewControllers.last {
                                    let toast = ToastMessage()
                                    previousVC.view.addSubview(toast)
                                    toast.configure(type: .basic, message: "일기가 비공개 되었어요.")
                                }
                            }
                        }
                    }
        )
        dialog.showAnimation()
    }
}
