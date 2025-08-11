//
//  VerificationCodeViewController.swift
//  HilingualPresentation
//
//  Created by 성현주 on 8/12/25.
//

import Foundation

import UIKit

public final class VerificationCodeViewController: BaseUIViewController<HomeViewModel> {

    // MARK: - Properties

    private let verificationCodeView = VerificationCodeView()

    // MARK: - Custom Method

    public override func setUI() {
        view.addSubviews(verificationCodeView)
    }

    public override func setLayout() {
        verificationCodeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    public override func navigationType() -> NavigationType? {
        return .backTitleMenu("나의 단어장")
    }

    // MARK: - Bind

}
