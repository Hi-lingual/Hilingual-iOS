//
//  EditProfileView.swift
//  HilingualPresentation
//
//  Created by 성현주 on 8/20/25.
//

import UIKit
import SnapKit

final class EditProfileView: BaseUIView {

    // MARK: - UI Components

    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_arrow_left_black_24_ios", in: .module, compatibleWith: nil), for: .normal)
        return button
    }()

    let modal: Modal = {
        let modal = Modal()
        modal.isHidden = true
        modal.configure(
            title: "이미지 선택하기",
            items: [
                ("기본 이미지로 변경하기", UIImage(resource: .icImage24Ios), {
                }),
                ("갤러리에서 선택하기", UIImage(resource: .icGallary24Ios), {
                })
            ]
        )
        return modal
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "내 정보 수정"
        label.textColor = .black
        label.font = .suit(.head_b_18)
        return label
    }()

    let profileImageView = EditableProfileImageView()

    let nicknameRow = ProfileRow(title: "닉네임", value: "sereal")
    let socialRow = ProfileRow(title: "연결된 소셜 계정", value: "애플 로그인")

    let withdrawButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원탈퇴", for: .normal)
        button.setTitleColor(.gray400, for: .normal)
        button.titleLabel?.font = .suit(.caption_m_12)
        return button
    }()

    // MARK: - UI Setup

    override func setUI() {
        backgroundColor = .white
        addSubviews(backButton, titleLabel, profileImageView, nicknameRow, socialRow, withdrawButton, modal)
    }

    override func setLayout() {

        modal.snp.makeConstraints { $0.edges.equalToSuperview() }


        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(16)
            $0.size.equalTo(24)
        }

        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(backButton)
            $0.centerX.equalToSuperview()
        }

        profileImageView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(40)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(120)
        }

        nicknameRow.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(48)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(58)
        }

        socialRow.snp.makeConstraints {
            $0.top.equalTo(nicknameRow.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(nicknameRow)
            $0.height.equalTo(58)
        }

        withdrawButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(40)
            $0.centerX.equalToSuperview()
        }
    }
}

extension EditProfileView {
    public func configure(profileImageURL: String?, nickname: String, provider: String) {
        profileImageView.setImage(urlString: profileImageURL)
        nicknameRow.setValue(value: nickname)
        socialRow.setValue(value: provider)
    }
}
