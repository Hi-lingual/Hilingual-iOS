//
//  MypageViewController.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Foundation
import Foundation
import UIKit

public final class MypageViewController: BaseUIViewController<HomeViewModel> {

    // MARK: - Properties

    private let mypageView = MypageView()

    // MARK: - Life Cycle

    public override func setUI() {
        super.setUI()
        view.addSubview(mypageView)
    }

    public override func setLayout() {
        mypageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: - Bind

    public override func bind(viewModel: HomeViewModel) {

    }

    // MARK: - Action

    public override func addTarget() {

    }

    // MARK: - Navigation

}
