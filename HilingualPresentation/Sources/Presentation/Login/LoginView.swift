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
        addSubview(loginButton)

        loginButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
