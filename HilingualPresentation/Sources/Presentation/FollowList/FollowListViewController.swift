//
//  FollowListViewController.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 8/15/25.
//

import UIKit
import Combine

public final class FollowListViewController: BaseUIViewController<FollowListViewModel> {
    
    // MARK: - SegmentedControl
    
    private lazy var followerListViewController: FollowerListViewController = {
        guard let viewModel = self.viewModel else {
            fatalError("FollowListViewModel is not initialized")
        }
        return FollowerListViewController(viewModel: viewModel, diContainer: self.diContainer)
    }()

    private lazy var followingListViewController: FollowingListViewController = {
        guard let viewModel = self.viewModel else {
            fatalError("FollowListViewModel is not initialized")
        }
        return FollowingListViewController(viewModel: viewModel, diContainer: self.diContainer)
    }()
    
    private lazy var segmentedControl = SegmentedControl(
        viewControllers: [followerListViewController, followingListViewController],
        titles: ["팔로워", "팔로잉"],
        parentViewController: self
    )
    
    // MARK: - Life Cycle
    
    public override init(viewModel: FollowListViewModel, diContainer: ViewControllerFactory) {
        super.init(viewModel: viewModel, diContainer: diContainer)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
        
        viewModel?.bind()
        viewModel?.fetchFollowers()
        viewModel?.fetchFollowing()
        
        segmentedControl.onIndexChange = { [weak self] (index: Int) in
            switch index {
            case 0:
                self?.viewModel?.fetchFollowers()
            case 1:
                self?.viewModel?.fetchFollowing()
            default:
                break
            }
        }
    }
    
    // MARK: - Setup Methods
    
    public override func setUI() {
        view.addSubview(segmentedControl)
    }
    
    public override func setLayout() {
        segmentedControl.snp.makeConstraints {
          $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
          $0.leading.trailing.equalToSuperview()
          $0.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Navigation
    
    public override func navigationType() -> NavigationType? {
        return .backTitle("팔로우")
    }
    
    @objc public override func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
