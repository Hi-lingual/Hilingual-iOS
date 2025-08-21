//
//  UserFeedProfileViewController.swift
//  HilingualPresentation
//
//  Created by 조영서 on 8/21/25.
//

import UIKit
import Foundation

public final class UserFeedProfileViewController: BaseUIViewController<UserFeedProfileViewModel> {

    // MARK: - Properties

    private let userFeedProfileView = UserFeedProfileView()

    // MARK: - Lifecycle

    public override func setUI() {
        super.setUI()
        view.addSubview(userFeedProfileView)
    }

    public override func setLayout() {
        userFeedProfileView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public override func navigationType() -> NavigationType? {
        return.backTitleMenu("")
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
