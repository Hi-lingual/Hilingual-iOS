//
//  OnBoardingView.swift
//  HilingualPresentation
//
//  Created by 성현주 on 7/8/25.
//

import UIKit
import SnapKit

final class OnBoardingView: BaseUIView {

    // MARK: - UI Components

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "프로필 작성"
        label.font = .suit(.head_b_18)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()


    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "img_profile_normal_ios", in: .module, compatibleWith: nil)
        imageView.layer.cornerRadius = 60
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .gray100
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.gray200.cgColor
        return imageView
    }()

    let startButton: CTAButton = {
        //TODO: - 서버 연결이후 변경하기
        CTAButton(style: .TextButton("시작하기"), autoBackground: false)
    }()

    let nickNameLabel: UILabel = {
        let label = UILabel()
        label.font = .suit(.body_sb_16)
        label.attributedText = .suit(.body_sb_16, text: "닉네임")
        label.textAlignment = .left
        label.textColor = .black
        label.text = "닉네임"
        return label
    }()

    let nicknameTextField: TextField = {
        let textfield = TextField()
        textfield.setPlaceholder("한글, 영문, 숫자 조합만 가능")
        return textfield
    }()

    private lazy var nicknameStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nickNameLabel, nicknameTextField])
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()

    // MARK: - Custom Method

    override func setUI() {
        addSubviews(
            titleLabel,
            profileImageView,
            nicknameStackView,
            startButton
        )
    }

    override func setLayout() {
        titleLabel.snp.makeConstraints {
               $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(12)
               $0.centerX.equalToSuperview()
           }

        profileImageView.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(45) 
                $0.centerX.equalToSuperview()
                $0.width.height.equalTo(120)
            }

        nicknameStackView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        startButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(50)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}
