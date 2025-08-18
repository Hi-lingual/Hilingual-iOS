//
//  ToastMessage.swift
//  HilingualPresentation
//
//  Created by 진소은 on 8/16/25.
//

import UIKit
import SnapKit

enum ToastMessageType {
    case basic
    case withButton
}

final class ToastMessage: UIView {
    
    // MARK: - Properties

    private var messageTrailingToButton: Constraint?
    private var messageTrailingToSuperview: Constraint?
    
    private var action: (() -> Void)?

    // MARK: - UI Components
    
    private let messageLabel = UILabel()
    private let actionButton = UIButton(type: .system)

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - UI/Layout
    
    private func setupUI() {
        backgroundColor = .gray500
        layer.cornerRadius = 8
        clipsToBounds = true

        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0
        messageLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        messageLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        actionButton.setContentHuggingPriority(.required, for: .horizontal)
        actionButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        actionButton.contentEdgeInsets = UIEdgeInsets(top: 7, left: 11, bottom: 7, right: 11)

        actionButton.setTitleColor(.white, for: .normal)
        actionButton.titleLabel?.font = .suit(.body_sb_14)
        actionButton.backgroundColor = .gray700
        actionButton.layer.cornerRadius = 6

        actionButton.addTarget(self, action: #selector(handleAction), for: .touchUpInside)

        addSubviews(messageLabel, actionButton)
    }

    private func setupLayout() {
        actionButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(28)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(31)
        }

        messageLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(28)
            $0.top.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(8)

            self.messageTrailingToButton = $0.trailing
                .equalTo(actionButton.snp.leading)
                .offset(-8).constraint

            self.messageTrailingToSuperview = $0.trailing.equalToSuperview()
                .inset(28).constraint
        }

        messageTrailingToButton?.deactivate()
        messageTrailingToSuperview?.activate()
    }
    
    // MARK: - Configure
    
    func configure(
        type: ToastMessageType,
        message: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        messageLabel.attributedText = .suit(.body_m_16, text: message)
        apply(type: type, actionTitle: actionTitle, action: action)
    }

    private func apply(type: ToastMessageType, actionTitle: String?, action: (() -> Void)?) {
        self.action = action

        switch type {
        case .withButton:
            let title = actionTitle ?? "보러가기"
            actionButton.setTitle(title, for: .normal)
            actionButton.isHidden = false
            messageTrailingToSuperview?.deactivate()
            messageTrailingToButton?.activate()
            
            self.snp.makeConstraints {
                $0.width.equalTo(343)
                $0.height.equalTo(52)
            }

        case .basic:
            actionButton.isHidden = true
            messageTrailingToButton?.deactivate()
            messageTrailingToSuperview?.activate()
        }
    }

    // MARK: - Action
    
    @objc private func handleAction() { action?() }
}

