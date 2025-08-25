//
//  AlarmSettingViewController.swift
//  HilingualPresentation
//
//  Created by 성현주 on 8/25/25.
//

import Foundation
import UIKit

public final class AlarmSettingViewController: BaseUIViewController<HomeViewModel> {

    // MARK: - Properties

    private let alarmSettingView = AlarmSettingView()

    // MARK: - Life Cycle

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    public override func setUI() {
        super.setUI()
        view.addSubview(alarmSettingView)
    }

    public override func navigationType() -> NavigationType? {
        return .backTitle("알림 설정")
    }

    public override func setLayout() {
        alarmSettingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Bind

    public override func bind(viewModel: HomeViewModel) {

    }

    // MARK: - Action

    public override func addTarget() {

    }

}
