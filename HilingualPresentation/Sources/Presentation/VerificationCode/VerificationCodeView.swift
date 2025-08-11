//
//  VerificationCodeView.swift
//  HilingualPresentation
//
//  Created by 성현주 on 8/12/25.
//


import UIKit
import SnapKit
import Combine

final class VerificationCodeView: BaseUIView {

    // MARK: - UI

    let codeView: OneTimeCodeView = {
        let v = OneTimeCodeView()
        v.setState(.error("ddd"))
        return v
    }()

    let questionTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Q. 인증 번호란?"
        l.font = .systemFont(ofSize: 15, weight: .semibold)
        l.textColor = .label
        return l
    }()

    let guideLabel: UILabel = {
        let l = UILabel()
        l.text = "사전 예약 신청한 분들을 대상으로 가입 인증 번호가 발급되었어요. 인증 번호를 보유하신 경우에만 가입이 가능해요."
        l.font = .systemFont(ofSize: 13)
        l.textColor = .secondaryLabel
        l.numberOfLines = 0
        return l
    }()

    let notReceivedButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("인증 번호가 오지 않았나요?", for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        return b
    }()

    let submitButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("인증하기", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.setTitleColor(.white.withAlphaComponent(0.5), for: .disabled)
        b.backgroundColor = .black
        b.layer.cornerRadius = 10
        b.isEnabled = false
        return b
    }()

    private let bottomSpacer = UIView()

    // MARK: - Methods
    override func setUI() {
        addSubviews(codeView, questionTitleLabel, guideLabel, notReceivedButton, submitButton, bottomSpacer)
    }

    override func setLayout() {

        codeView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(32)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(52)
        }

        questionTitleLabel.snp.makeConstraints {
            $0.top.equalTo(codeView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        guideLabel.snp.makeConstraints {
            $0.top.equalTo(questionTitleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        notReceivedButton.snp.makeConstraints {
            $0.top.equalTo(guideLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        submitButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(52)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-12)
        }

    }
}
