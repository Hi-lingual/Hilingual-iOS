//
//  RecoveryView.swift
//  HilingualPresentation
//
//  Created by youngseo on 6/18/26.
//

import UIKit
import SnapKit

final class RecoveryView: UIView {

    // MARK: - Callback
    public var onTapRecovery: (() -> Void)?

    // MARK: - UI Components
    
    private let recoveryCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        view.layer.cornerRadius = 8
        return view
    }()

    private let recoveryLabel: UILabel = {
        let label = UILabel()
        label.text = "연속 작성이 끊겼어요.\n광고 한 편 보면 연속 기록을 살릴 수 있어요."
        label.font = .pretendard(.body_m_14)
        label.textColor = .gray500
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
        
    private let recoveryButton = CTAButton(
        style: .IconTextButton(
            iconName: "ic_return_16_ios",
            text: "기록 살리기"
        )
    )

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        addTargets()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup

    private func setupUI() {
        addSubviews(recoveryCardView, recoveryButton)
        recoveryCardView.addSubview(recoveryLabel)
    }

    private func setupLayout() {
        recoveryCardView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(77)
        }
        
        recoveryLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        recoveryButton.snp.makeConstraints {
            $0.top.equalTo(recoveryCardView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Actions

    private func addTargets() {
        recoveryButton.addTarget(
            self,
            action: #selector(didTapRecoveryButton),
            for: .touchUpInside
        )
    }
    
    @objc
    private func didTapRecoveryButton() {
        onTapRecovery?()
    }
}
