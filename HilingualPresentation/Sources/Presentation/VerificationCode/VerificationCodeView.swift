//
//  VerificationCodeView.swift
//  HilingualPresentation
//
//  Created by 성현주 on 8/12/25.
//


import UIKit
import SnapKit

final class VerificationCodeView: BaseUIView {

    // MARK: - UI

    let codeView: VerificationCodeInputView = {
        let view = VerificationCodeInputView()
        return view
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .pretendard(.head_sb_18, text: "인증번호 입력")
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    private let infoContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        view.layer.masksToBounds = true
        view.isUserInteractionEnabled = false
        return view
    }()

    private let infoStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()

    let questionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Q. 인증 번호란?"
        label.font = .pretendard(.head_sb_16)
        label.textColor = .label
        return label
    }()

    let guideLabel: UILabel = {
        let label = UILabel()
        label.text = "사전 예약을 신청한 분들을 대상으로 가입 인증 번호가 발급되었어요. 인증 번호를 보유하신 경우에만 가입이 가능해요.\n\n알림을 신청한 이메일을 확인해주세요."
        label.font = .pretendard(.body_r_14)
        label.textColor = .gray500
        label.numberOfLines = 0
        return label
    }()

    let notReceivedButton: UIButton = {
        let button = UIButton(type: .system)
        let title = "인증 번호가 오지 않았나요?"
        let color: UIColor = .gray500
        let attr = NSAttributedString(
            string: title,
            attributes: [
                .font: UIFont.pretendard(.body_r_14),
                .foregroundColor: color,
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .underlineColor: color
            ]
        )
        button.setAttributedTitle(attr, for: .normal)
        button.contentHorizontalAlignment = .leading
        button.titleLabel?.numberOfLines = 1
        return button
    }()

    let submitButton: CTAButton = {
        CTAButton(style: .TextButton("인증하기"), autoBackground: true)
    }()

    // MARK: - Methods
    override func setUI() {
        addSubviews(titleLabel,
                    codeView,
                    infoContainer,
                    notReceivedButton,
                    submitButton)

        infoContainer.addSubview(infoStack)
        infoStack.addArrangedSubview(questionTitleLabel)
        infoStack.addArrangedSubview(guideLabel)
    }

    override func setLayout() {
        titleLabel.snp.makeConstraints {
               $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(12)
               $0.centerX.equalToSuperview()
           }

        codeView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.greaterThanOrEqualTo(52)
        }

        infoContainer.snp.makeConstraints {
            $0.top.equalTo(codeView.snp.bottom).offset(17)
            $0.leading.trailing.equalToSuperview()
        }

        infoStack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
        }

        notReceivedButton.snp.makeConstraints {
            $0.top.equalTo(infoContainer.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        submitButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(50)
        }
    }
}
