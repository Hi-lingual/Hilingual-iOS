//
//  HighlightingFeedback.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 7/7/25.
//

import UIKit
import SnapKit

final class HighlightingFeedback: UIView {
    
    // MARK: - UI Components
    
    private let myChip = Chip(type: .me)
    private let aiChip = Chip(type: .ai)
    
    let originalLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body_r_16)
        label.textColor = .gray700
        label.numberOfLines = 0
        label.textAlignment = .left
        label.lineBreakMode = .byClipping
        return label
    }()
    
    let rewriteLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body_r_16)
        label.textColor = .hilingualOrange
        label.numberOfLines = 0
        label.textAlignment = .left
        label.lineBreakMode = .byClipping
        return label
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .gray200
        return view
    }()
    
    let explainLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body_r_14)
        label.textColor = .hilingualBlack
        label.numberOfLines = 0
        label.textAlignment = .left
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    private let originalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .firstBaseline
        return stack
    }()
    
    private let rewriteStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .firstBaseline
        return stack
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setStyle() {
        backgroundColor = .white
        layer.cornerRadius = 8
        clipsToBounds = true
    }
    
    private func setUI() {
        originalStack.addArrangedSubviews(myChip, originalLabel)
        rewriteStack.addArrangedSubviews(aiChip, rewriteLabel)
        addSubviews(originalStack, rewriteStack,
                    divider, explainLabel)
    }
    
    private func setLayout() {
        originalStack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().inset(12)
        }

        rewriteStack.snp.makeConstraints {
            $0.top.equalTo(originalStack.snp.bottom).offset(2)
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().inset(12)
        }

        divider.snp.makeConstraints {
            $0.top.equalTo(rewriteStack.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().inset(12)
            $0.height.equalTo(0.5)
        }

        explainLabel.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(11)
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().offset(-12)
        }
    }
    
    func configure(original: String, rewrite: String, explanation: String) {
        originalLabel.attributedText = .pretendard(.body_r_16, text: original)
        rewriteLabel.attributedText = .pretendard(.body_m_16, text: rewrite)
        explainLabel.attributedText = .pretendard(.body_m_14, text: explanation)
    }
}
