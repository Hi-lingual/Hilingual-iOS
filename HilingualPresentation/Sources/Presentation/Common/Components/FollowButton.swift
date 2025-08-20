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
        didSet { setStyle() }
    }
    
    private var currentSize: ButtonSize = .short {
        didSet { updateSize() }
    }
    
    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.6 : 1.0
        }
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        updateSize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setStyle() {
        titleLabel?.font = .suit(.body_sb_14)
        layer.cornerRadius = 4
        clipsToBounds = true
        
        switch currentState {
        case .follow:
            backgroundColor = .hilingualBlack
            setTitle("팔로우", for: .normal)
            setTitleColor(.white, for: .normal)
            layer.borderWidth = 0
        case .following:
            backgroundColor = .white
            setTitle("팔로잉", for: .normal)
            setTitleColor(.gray500, for: .normal)
            layer.borderWidth = 1
            layer.borderColor = UIColor.gray200.cgColor
        case .mutualFollow:
            backgroundColor = .hilingualBlack
            setTitle("맞팔로우", for: .normal)
            setTitleColor(.white, for: .normal)
            layer.borderWidth = 0
        case .block:
            backgroundColor = .hilingualBlack
            setTitle("차단", for: .normal)
            setTitleColor(.white, for: .normal)
            layer.borderWidth = 0
        case .unblock:
            backgroundColor = .white
            setTitle("차단 해제", for: .normal)
            setTitleColor(.gray500, for: .normal)
            layer.borderWidth = 1
            layer.borderColor = UIColor.gray200.cgColor
        }
    }
    
    private func updateSize() {
        snp.remakeConstraints {
            $0.height.equalTo(33)
            $0.width.equalTo(currentSize == .short ? 80 : 343)
        }
    }
    
    // MARK: - Public Methods
    
    func configure(state: FollowButtonState, size: ButtonSize) {
        self.currentState = state
        self.currentSize = size
    }
}
