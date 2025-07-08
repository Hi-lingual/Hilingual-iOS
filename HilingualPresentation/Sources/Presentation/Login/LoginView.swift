//
//  LoginView.swift
//  HilingualPresentation
//
//  Created by 성현주 on 7/5/25.
//

import UIKit
import SnapKit

final class LoginView: UIView {

    // MARK: - UI

    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("로그인", for: .normal)
        return button
    }()

    let customTextfield: TextField = {
        let textfield = TextField()
        return textfield
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    private func setupLayout() {
        addSubviews(loginButton, customTextfield)

        loginButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        customTextfield.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalTo(loginButton.snp.bottom)
        }
    }
}
