//
//  OnBoardingView.swift
//  HilingualPresentation
//
//  Created by 성현주 on 7/8/25.
//

import UIKit
import SnapKit

final class OnBoardingView: BaseUIView {

    // MARK: - Public Callback

    var onSelectDefaultImage: (() -> Void)?
    var onSelectFromGallery: (() -> Void)?

    // MARK: - UI Components

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "프로필 작성"
        label.font = .suit(.head_b_18)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    let modal: Modal = {
        let modal = Modal()
        modal.isHidden = true
        return modal
    }()

    let profileImageView = EditableProfileImageView()

    let startButton: CTAButton = {
        //TODO: - 서버 연결이후 변경하기
        CTAButton(style: .TextButton("가입하기"), autoBackground: true)
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

    let nicknameTextField: nickNameTextField = {
        let textfield = nickNameTextField()
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
            startButton,
            modal
        )
        configureModal()
    }

    override func setLayout() {
        modal.snp.makeConstraints { $0.edges.equalToSuperview() }

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

    private func configureModal() {
        modal.configure(
            title: "이미지 선택하기",
            items: [
                ("기본 이미지로 변경하기", UIImage(resource: .icImage24Ios), { [weak self] in
                    self?.onSelectDefaultImage?()
                    self?.modal.dismissModal()
                }),
                ("갤러리에서 선택하기", UIImage(resource: .icGallary24Ios), { [weak self] in
                    self?.onSelectFromGallery?()
                    self?.modal.dismissModal()
                })
            ]
        )
    }
}
