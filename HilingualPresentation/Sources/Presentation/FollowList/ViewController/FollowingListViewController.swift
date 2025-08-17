//
//  FollowingListViewController.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 8/16/25.
//

import UIKit

public final class FollowingListViewController: UIViewController {
    
    private let followListView = FollowListView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(followListView)
        followListView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        followListView.updateView(for: .following)
    }
}
