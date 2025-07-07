//
//  HighlightingFeedback.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 7/7/25.
//

import UIKit

final class HighlightingFeedback: UIView {
    
    // MARK: - UI Components
    
    private let myChip = Chip(type: .me)
    private let aiChip = Chip(type: .ai)
    
    let originalLabel: UILabel = {
        let label = UILabel()
        label.font = .suit(.body_r_16)
        label.textColor = .gray700
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    let rewriteLabel: UILabel = {
        let label = UILabel()
        label.font = .suit(.body_m_16)
        label.textColor = .hilingualOrange
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .gray200
        return view
    }()
    
    let explainLabel: UILabel = {
        let label = UILabel()
        label.font = .suit(.body_m_14)
        label.textColor = .hilingualBlack
        label.numberOfLines = 0
        label.textAlignment = .left
        label.lineBreakMode = .byClipping
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
    
    init(original: String, rewrite: String, explanation: String) {
        super.init(frame: .zero)
        
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
        originalLabel.text = original
        rewriteLabel.text = rewrite
        explainLabel.text = explanation
    }
}

// MARK: - Preview

@available(iOS 17.0, *)
#Preview {
    HighlightingFeedbackPreview()
}

final class HighlightingFeedbackPreview: UIView {
    private let feedbackView = HighlightingFeedback(original: "", rewrite: "", explanation: "")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(feedbackView)
        feedbackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        feedbackView.configure(
            original: "I was planning to arrive it here around 13:30",
            rewrite: "I was planning to arrive here around 1:30 p.m",
            explanation: "arrive는 자동사이기 때문에 직접 목적어 ‘it’을 쓸 수 없어요. ‘arrive at the station’, ‘arrive here’처럼 써야 맞는 표현이에요!"
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
