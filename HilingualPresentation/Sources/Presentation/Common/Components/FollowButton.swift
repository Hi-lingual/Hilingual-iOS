//
//  FollowButton.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 8/13/25.
//

import UIKit

final class FollowButton: UIButton {
    
    // MARK: - Enum
    
    enum FollowButtonState {
        case follow         // 팔로우
        case following      // 팔로잉
        case mutualFollow   // 맞팔로우
        case block          // 차단
        case unblock        // 차단 해제
    }
    
    enum ButtonSize {
        case short
        case long
    }
    
    // MARK: - Properties
    
    private var currentState: FollowButtonState = .follow {
        didSet {
            updateFollowingState()
            setStyle()
        }
    }
    
    private var isFollowing: Bool = false
    private var currentSize: ButtonSize = .short
    
    // MARK: - UI Components
    
    private let followButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .suit(.body_sb_14)
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray200.cgColor
        return button
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateFollowingState() {
        switch currentState {
        case .following, .unblock:
            isFollowing = true
        default:
            isFollowing = false
        }
        
        let title: String
        switch currentState {
        case .follow: title = "팔로우"
        case .following: title = "팔로잉"
        case .mutualFollow: title = "맞팔로우"
        case .block: title = "차단"
        case .unblock: title = "차단 해제"
        }
        followButton.setTitle(title, for: .normal)
    }
    
    // MARK: - Setup Methods
    
    private func setStyle() {
        if isFollowing {
            followButton.backgroundColor = .white
            followButton.layer.borderWidth = 1
            followButton.layer.borderColor = UIColor.gray200.cgColor
            followButton.setTitleColor(.gray500, for: .normal)
        } else {
            followButton.backgroundColor = .hilingualBlack
            followButton.layer.borderWidth = 0
            followButton.setTitleColor(.white, for: .normal)
        }
    }
    
    private func setUI() {
        addSubview(followButton)
    }
    
    private func setLayout() {
        followButton.snp.makeConstraints {
            $0.height.equalTo(33)
            $0.center.equalToSuperview()
        }
    }
    
    // MARK: - Public Methods
    
    func configure(state: FollowButtonState, size: ButtonSize) {
        self.currentSize = size
        self.currentState = state
        followButton.snp.makeConstraints {
            $0.width.equalTo(size == .short ? 80 : 343)
        }
    }
    
    func setFollowing(_ isFollowing: Bool) {
        self.isFollowing = isFollowing
    }
}
