//
//  FollowListEmptyView.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 8/15/25.
//

import UIKit

final class FollowListEmptyView: UIView {
    
    private let noFeedView = NoFeedView()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setUI() {
        addSubview(noFeedView)
    }
    
    private func setLayout() {
        noFeedView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(160)
            $0.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Configure
    
    func configure(type: FollowListType) {
        let message: String
        switch type {
        case .follower:
            message = "아직 팔로워가 없어요."
        case .following:
            message = "아직 팔로우 중인 계정이 없어요."
        }
        noFeedView.configure(message: message)
    }
}

//MARK: - Preview

#Preview {
    FollowListEmptyView()
}
