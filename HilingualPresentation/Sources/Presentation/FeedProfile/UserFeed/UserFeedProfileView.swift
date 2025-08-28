//
//  UserFeedProfileView.swift
//  HilingualPresentation
//
//  Created by 조영서 on 8/21/25.
//

import UIKit
import SnapKit

final class UserFeedProfileView: BaseUIView {
    
    // MARK: - UI Components
    
    private let myFeedView = FeedProfileView()
    private(set) var button = FollowButton()
    let feedContainer = UIView()
    
    private let blockedStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .center
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .suit(.head_b_18)
        label.textColor = .black
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .suit(.body_m_16)
        label.textColor = .gray400
        label.text = "차단을 해제하면 글을 확인할 수 있어요."
        return label
    }()
    
    private let modal: Modal = {
        let modal = Modal()
        return modal
    }()
    
    private let blockModal = BlockModal()
    
    // MARK: - Callbacks
    
    var onBlockTapped: (() -> Void)?
    var onBlockConfirmTapped: (() -> Void)?
    var onReportTapped: (() -> Void)?
    var onUnblockTapped: (() -> Void)?
    
    // MARK: - State
    
    private enum ButtonState {
        case follow
        case following
        case unblock
    }
    private var currentButtonState: ButtonState = .follow
    
    // MARK: - Setup
    
    override func setUI() {
        addSubviews(myFeedView, button, feedContainer, blockedStack, modal)
        blockedStack.isHidden = true
        blockedStack.addArrangedSubviews(titleLabel, subTitleLabel)
        button.configure(state: .follow)
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    override func setLayout() {
        myFeedView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        button.snp.makeConstraints {
            $0.top.equalTo(myFeedView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        feedContainer.snp.makeConstraints {
            $0.top.equalTo(button.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        blockedStack.snp.makeConstraints {
            $0.top.equalTo(button.snp.bottom).offset(140)
            $0.centerX.equalToSuperview()
        }
        
        modal.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    // MARK: - Public
    
    func configureProfile(
        nickname: String,
        profileImageURL: String?,
        follower: Int,
        following: Int,
        streak: Int
    ) {
        myFeedView.configure(
            nickname: nickname,
            profileImageURL: profileImageURL,
            follower: follower,
            following: following,
            streak: streak
        )
        titleLabel.text = "\(nickname)님의 글을 확인할 수 없어요."
    }
    
    func showModal() {
        modal.configure(
            title: "",
            items: [
                ("계정 차단하기",
                 UIImage(named: "ic_block_24_2_ios", in: .module, compatibleWith: nil),
                 { [weak self] in self?.onBlockTapped?() }),
                ("계정 신고하기",
                 UIImage(named: "ic_report_24_ios", in: .module, compatibleWith: nil),
                 { [weak self] in self?.onReportTapped?() })
            ]
        )
        modal.isHidden = false
        bringSubviewToFront(modal)
        
        DispatchQueue.main.async { [weak self] in
            self?.modal.showAnimation()
        }
    }
    
    func showBlockDialog() {
        blockModal.show(in: self)
        blockModal.onApplyTapped = { [weak self] in
            self?.onBlockConfirmTapped?()
            self?.setButtonState(.unblock)
            self?.showBlockedView()
        }
    }
    
    func dismissBlockDialog() {
        blockModal.dismiss()
    }
    
    func dismissModal() {
        modal.isHidden = true
    }
    
    func showBlockedView() {
        feedContainer.isHidden = true
        blockedStack.isHidden = false
    }
    
    func restoreFeedView() {
        feedContainer.isHidden = false
        blockedStack.isHidden = true
    }
    
    // MARK: - Private
    
    @objc private func buttonTapped() {
        switch currentButtonState {
        case .follow:
            setButtonState(.following)
        case .following:
            setButtonState(.follow)
        case .unblock:
            onUnblockTapped?()
            setButtonState(.follow)
            restoreFeedView()
        }
    }
    
    private func setButtonState(_ state: ButtonState) {
        currentButtonState = state
        switch state {
        case .follow:
            button.configure(state: .follow)
        case .following:
            button.configure(state: .following)
        case .unblock:
            button.configure(state: .unblock)
        }
    }
}
