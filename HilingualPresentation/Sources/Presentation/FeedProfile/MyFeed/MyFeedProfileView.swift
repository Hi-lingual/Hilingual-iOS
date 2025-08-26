//
//  MyFeedProfileView.swift
//  HilingualPresentation
//
//  Created by 조영서 on 8/21/25.
//

import UIKit
import SnapKit

final class MyFeedProfileView: BaseUIView {
    
    // MARK: - UI Components
    
    private let myFeedView = FeedProfileView()
    private var segmentedControl: SegmentedControl?
    
    // MARK: - Setup
    
    override func setUI() {
        addSubview(myFeedView)
    }
    
    override func setLayout() {
        myFeedView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - Public Method
    
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
    }

    func configureSegmentedControl(
        parentVC: UIViewController,
        viewControllers: [UIViewController],
        titles: [String]
    ) {
        let control = SegmentedControl(
            viewControllers: viewControllers,
            titles: titles,
            parentViewController: parentVC
        )
        self.segmentedControl = control
        addSubview(control)

        control.snp.makeConstraints {
            $0.top.equalTo(myFeedView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
