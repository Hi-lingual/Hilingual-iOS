//
//  LoginView.swift
//  HilingualPresentation
//
//  Created by 성현주 on 7/5/25.
//

import AuthenticationServices

final class LoginView: BaseUIView {

    let appleLoginButton = ASAuthorizationAppleIDButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(appleLoginButton)
        appleLoginButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(50)
            $0.width.equalTo(280)
        }
    }
}
