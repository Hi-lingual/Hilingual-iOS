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

    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "일기로 시작하는 일상 속 영어 습관"
        label.font = .pretendard(.head_sb_16)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "img_logo_ios", in: .module, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "img_login_ios_v2", in: .module, compatibleWith: nil)
        imageView.contentMode = .scaleAspectFit
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
                .foregroundColor: UIColor.gray400,
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
        backgroundColor = .white
        addSubviews(
            subtitleLabel,
            logoImageView,
            appleLoginButton,
            characterImageView,
            privacyPolicyButton
        )
    }

    override func setLayout() {
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(132)
            $0.centerX.equalToSuperview()
        }

        logoImageView.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(50)
        }

        appleLoginButton.snp.makeConstraints {
            $0.bottom.equalTo(privacyPolicyButton.snp.top).offset(-16)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(58)
        }

        characterImageView.snp.makeConstraints {
            $0.width.equalTo(375)
            $0.height.equalTo(260)
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(261)
            $0.centerX.equalToSuperview()
        }

        privacyPolicyButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(16)
            $0.centerX.equalToSuperview()
        }
    }
}
