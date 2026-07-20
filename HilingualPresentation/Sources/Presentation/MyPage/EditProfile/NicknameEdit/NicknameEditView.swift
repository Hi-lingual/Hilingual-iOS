//
//  NicknameEditView.swift
//  HilingualPresentation
//
//  Created by 성현주 on 5/16/26.
//

import UIKit
import SnapKit

final class NicknameEditView: BaseUIView {

    // MARK: - UI Components

    let nicknameLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .pretendard(.body_m_16, text: "닉네임")
        label.textColor = .hilingualBlack
        return label
    }()

    let nicknameTextField: nickNameTextField = {
        let textField = nickNameTextField()
        textField.setPlaceholder("한글, 영문, 숫자 조합만 가능")
        return textField
    }()

    let changeButton: CTAButton = {
        CTAButton(style: .TextButton("변경하기"), autoBackground: true)
    }()

    private lazy var nicknameStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nicknameLabel, nicknameTextField])
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()

    // MARK: - Setup

    override func setUI() {
        backgroundColor = .white
        addSubviews(nicknameStackView, changeButton)
    }

    override func setLayout() {
        nicknameStackView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        changeButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(keyboardLayoutGuide.snp.top).offset(-16)
        }
    }

    func configure(nickname: String) {
        nicknameTextField.setText(nickname)
    }
}
