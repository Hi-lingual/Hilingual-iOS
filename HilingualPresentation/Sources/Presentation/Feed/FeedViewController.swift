//
//  FeedViewController.swift
//  HilingualPresentation
//
//  Created by 조영서 on 8/18/25.
//

import UIKit
import Foundation

public final class FeedViewController: BaseUIViewController<FeedViewModel> {

    // MARK: - Properties

    private let feedView = FeedView()

    private lazy var recommendFeedVC = diContainer.makeFeedListViewController(type: .recommended)
    private lazy var followingFeedVC = diContainer.makeFeedListViewController(type: .following)

    // MARK: - Lifecycle

    public override func setUI() {
        feedView.configureSegmentedControl(
            parentVC: self,
            viewControllers: [recommendFeedVC, followingFeedVC],
            titles: ["추천", "팔로잉"]
        )
    }
    
    public override func loadView() {
        self.view = feedView
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
