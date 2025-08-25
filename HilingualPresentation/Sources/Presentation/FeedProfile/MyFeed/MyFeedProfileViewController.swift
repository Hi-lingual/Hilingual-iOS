//
//  MyFeedProfileViewController.swift
//  HilingualPresentation
//
//  Created by 조영서 on 8/21/25.
//

import UIKit
import Foundation

public final class MyFeedProfileViewController: BaseUIViewController<FeedProfileViewModel> {

    // MARK: - Properties
    private let myFeedProfileView = MyFeedProfileView()
    private let likedVC: FeedProfileListViewController
    private let sharedVC: FeedProfileListViewController
    
    // MARK: - Init
    public init(
        viewModel: FeedProfileViewModel,
        diContainer: any ViewControllerFactory,
        likedVC: FeedProfileListViewController,
        sharedVC: FeedProfileListViewController
    ) {
        self.likedVC = likedVC
        self.sharedVC = sharedVC
        super.init(viewModel: viewModel, diContainer: diContainer)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Lifecycle
    public override func setUI() {
        myFeedProfileView.configureSegmentedControl(
            parentVC: self,
            viewControllers: [sharedVC, likedVC],
            titles: ["공유한 일기", "공감한 일기"]
        )
    }
    
    public override func navigationType() -> NavigationType? {
        return .backOnly
    }
    
    public override func loadView() {
        self.view = myFeedProfileView
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
