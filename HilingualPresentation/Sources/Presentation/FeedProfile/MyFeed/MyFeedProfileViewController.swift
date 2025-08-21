//
//  MyFeedProfileViewController.swift
//  HilingualPresentation
//
//  Created by 조영서 on 8/21/25.
//

import UIKit
import Foundation

public final class MyFeedProfileViewController: BaseUIViewController<MyFeedProfileViewModel> {

    // MARK: - Properties

    private let myFeedProfileView = MyFeedProfileView()

    private lazy var recommendFeedVC = diContainer.makeRecommendFeedViewController()
    private lazy var followingFeedVC = diContainer.makeFollowingFeedViewController()

    // MARK: - Lifecycle

    public override func setUI() {
        myFeedProfileView.configureSegmentedControl(
            parentVC: self,
            viewControllers: [recommendFeedVC, followingFeedVC],
            titles: ["공유한 일기", "공감한 일기"]
        )
    }
    
    public override func navigationType() -> NavigationType? {
        return.backOnly
    }
    
    public override func loadView() {
        self.view = myFeedProfileView
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
