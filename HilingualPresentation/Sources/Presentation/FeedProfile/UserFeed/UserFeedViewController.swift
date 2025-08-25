//
//  UserFeedProfileViewController.swift
//  HilingualPresentation
//
//  Created by 조영서 on 8/21/25.
//

import UIKit
import Foundation

public final class UserFeedProfileViewController: BaseUIViewController<FeedProfileViewModel> {

    // MARK: - Properties

    private let userFeedProfileView = UserFeedProfileView()

    // MARK: - Lifecycle

    public override func setUI() {
    }
    
    public override func navigationType() -> NavigationType? {
        return.backTitleMenu("")
    }
    
    public override func loadView() {
        self.view = userFeedProfileView
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
