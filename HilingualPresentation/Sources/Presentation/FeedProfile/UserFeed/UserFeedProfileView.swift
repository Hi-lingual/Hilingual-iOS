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
    
    private let userFeedView = FeedProfileView()
    private let button = FollowButton()
    private let noFeedView = NoFeedView()
    
    // MARK: - Setup

    override func setUI() {
        addSubviews(userFeedView, button)
        
        button.configure(state: .follow, size: .long)
        noFeedView.configure(message: "아직 좋아요한 다이어리가 없어요.")
    }

    override func setLayout() {
        userFeedView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(9)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        button.snp.makeConstraints {
            $0.top.equalTo(userFeedView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        noFeedView.snp.makeConstraints {
            $0.top.equalTo(button.snp.bottom).offset(140)
            $0.horizontalEdges.equalToSuperview().inset(66.5)
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
