//
//  EditProfileViewController.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Combine
import Foundation
import UIKit

public final class EditProfileViewController: BaseUIViewController<HomeViewModel> {

    // MARK: - Properties

    private let editProfileView = EditProfileView()
    private let logoutTappedSubject = PassthroughSubject<Void, Never>()

    // MARK: - Life Cycle

    public override func setUI() {
        super.setUI()
        view.addSubview(editProfileView)
    }

    public override func setLayout() {
        editProfileView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    public override func navigationType() -> NavigationType? {
        return .backTitle("내 정보 수정")
    }

    public override func addTarget() {
    }

    public override func bind(viewModel: HomeViewModel) {

    }

    // MARK: - PrivatMethod
}
