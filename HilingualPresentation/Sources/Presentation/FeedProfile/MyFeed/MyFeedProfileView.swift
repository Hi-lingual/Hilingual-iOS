//
//  MyFeedProfileView.swift
//  HilingualPresentation
//
//  Created by 조영서 on 8/21/25.
//

import UIKit
import SnapKit

final class MyFeedProfileView: BaseUIView {
    
    var onSegmentChanged: ((Int) -> Void)?
    
    // MARK: - UI Components
    
    private let myFeedView = FeedUserProfile()
    private(set) var segmentedControl: SegmentedControl?
    private var segmentedTopConstraint: Constraint?
    
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
    
    // MARK: - Public Methods
    
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
            segmentedTopConstraint = $0.top.equalTo(myFeedView.snp.bottom).offset(20).constraint
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        control.onIndexChanged = { [weak self] index in
            self?.onSegmentChanged?(index)
        }
    }
    
    func setSelectedIndex(_ index: Int) {
        segmentedControl?.setSelectedIndexWithAPI = index
        onSegmentChanged?(index)
    }

    func setFollowSectionTappedAction(_ action: @escaping () -> Void) {
        myFeedView.onFollowSectionTapped = action
    }
    
    func updateHeader(offsetY: CGFloat) {
        guard let segmentedTopConstraint else { return }
        
        let progress = min(max(offsetY / 84, 0), 1)
        let alphaValue = 1 - progress * 1.4
        let transformValue = CGAffineTransform(translationX: 0, y: -progress * 40)
        let newOffset = max(20 - offsetY, -84)
        
        UIView.animate(
            withDuration: 0.15, delay: 0,
            options: [.curveEaseOut, .allowUserInteraction]) {
            self.myFeedView.alpha = alphaValue
            self.myFeedView.transform = transformValue
            segmentedTopConstraint.update(offset: newOffset)
            self.layoutIfNeeded()
        }
    }
}
