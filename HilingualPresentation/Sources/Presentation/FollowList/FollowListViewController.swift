//
//  FollowListViewController.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 8/15/25.
//

import UIKit

public final class FollowListViewController: BaseUIViewController<DiaryDetailViewModel> {
    
    // MARK: - SegmentedControl
    
//    private lazy var feedbackViewController = diContainer.makeFeedbackViewController(diaryId: diaryId)
//    private lazy var recommendedExpressionViewController = diContainer.makeRecommendedExpressionViewController(diaryId: diaryId)
    
//    private let segmentedControl = SegmentedControl(
//        viewControllers: [FollowerListViewController, FollowingListViewController],
//        titles: ["팔로워", "팔로잉"],
//        parentViewController: self
//    )
    
    // MARK: - UI Components
    
    // FollowListView
    
    // MARK: - Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
    }
    
    // MARK: - Setup Methods
    
    public override func setUI() {
        
    }
    
    public override func setLayout() {
       
    }
    
    // MARK: - Navigation
    
    public override func navigationType() -> NavigationType? {
        return .backTitle("팔로우")
    }
    
    @objc public override func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
