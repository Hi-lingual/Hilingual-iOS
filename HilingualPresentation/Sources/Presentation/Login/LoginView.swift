//
//  LoginView.swift
//  HilingualPresentation
//
//  Created by 성현주 on 7/5/25.
//

import UIKit
import SnapKit
import AuthenticationServices

final class LoginView: BaseUIView {

    // MARK: - UI Components

    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "img_logo_ios", in: .module, compatibleWith: nil)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "img_login_ios", in: .module, compatibleWith: nil)
        return imageView
    }()

    let appleLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(named: "gray900") ?? .black
        button.layer.cornerRadius = 8
        button.clipsToBounds = true

        let iconImageView = UIImageView()
        iconImageView.image = UIImage(
            named: "ic_apple_20_ios",
            in: .module,
            compatibleWith: nil
        )?.withRenderingMode(.alwaysOriginal)
        iconImageView.contentMode = .scaleAspectFit

        let titleLabel = UILabel()
        titleLabel.text = "Apple로 계속하기"
        titleLabel.font = .pretendard(.body_m_16)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center

        button.addSubview(iconImageView)
        button.addSubview(titleLabel)

        iconImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(20)
        }

        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        return button
    }()


    let privacyPolicyButton: UIButton = {
        let button = UIButton(type: .system)

        let title = "개인정보처리방침"
        let attributedTitle = NSAttributedString(
            string: title,
            attributes: [
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: UIColor.white,
                .font: UIFont.pretendard(.body_r_14)
            ]
        )

        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()


    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    override func setUI() {
        backgroundColor = .hilingualOrange
        addSubviews(
            logoImageView,
            appleLoginButton,
            characterImageView,
            privacyPolicyButton
        )
    }

    override func setLayout() {
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(252)
            $0.centerX.equalToSuperview()
        }

        appleLoginButton.snp.makeConstraints {
            $0.bottom.equalTo(privacyPolicyButton.snp.top).offset(-16)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(58)
        }

        characterImageView.snp.makeConstraints {
            $0.bottom.equalTo(appleLoginButton.snp.top).offset(1)
            $0.centerX.equalToSuperview()
        }

        privacyPolicyButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(16)
            $0.centerX.equalToSuperview()
        }
    }
}

// MARK: - Animation

extension LoginView {

    public func startSplashAnimation() {
        characterImageView.alpha = 0
        appleLoginButton.alpha = 0
        privacyPolicyButton.alpha = 0

        characterImageView.transform = CGAffineTransform(translationX: 0, y: 20)
        appleLoginButton.transform = CGAffineTransform(translationX: 0, y: 20)
        privacyPolicyButton.transform = CGAffineTransform(translationX: 0, y: 20)

        // 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
                self.logoImageView.transform = CGAffineTransform(translationX: 0, y: -72)
            })
        }

        // 2
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
                self.characterImageView.alpha = 1
                self.appleLoginButton.alpha = 1
                self.privacyPolicyButton.alpha = 1

                self.characterImageView.transform = .identity
                self.appleLoginButton.transform = .identity
                self.privacyPolicyButton.transform = .identity
            })
        }
    }
}
