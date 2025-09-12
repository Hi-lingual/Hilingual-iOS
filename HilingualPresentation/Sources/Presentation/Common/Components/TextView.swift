//
//  TextView.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 7/5/25.
//

import UIKit
import SnapKit

@MainActor
protocol TextViewDelegate: AnyObject {
    func textView(_ textView: TextView, didChangeTextCount count: Int)
}

final class TextView: UIView {
    
    // MARK: - Properties
    
    var maxCharacterCount: Int = 1000
    
    weak var delegate: TextViewDelegate?
    
    var text: String {
        get { textView.text }
        set { configure(text: newValue) }
    }
    
    // MARK: - UI Components
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .gray100
        textView.font = .suit(.body_r_16)
        textView.attributedText = .suit(.body_r_16, text: "", lineBreakMode: .byWordWrapping, forceWrap: true)
//        textView.attributedText = .suit(.body_r_16, text: "")
        textView.textColor = .black
        textView.isScrollEnabled = true
        textView.autocorrectionType = .no
        textView.spellCheckingType = .no
        textView.layer.borderWidth = 0
        textView.layer.borderColor = UIColor.hilingualBlack.cgColor
//        textView.textContainer.lineBreakMode = .byWordWrapping
//        textView.textContainer.widthTracksTextView = true
//        textView.textContainer.lineFragmentPadding = 0
        return textView
    }()
    
    private var placeholderLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .suit(.body_r_16, text: "What’s been going on today?")
        label.textColor = .gray400
        return label
    }()

    private var countLabel: UILabel = {
        let label = UILabel()
        label.font = .suit(.caption_r_12)
        label.textColor = .gray400
        label.textAlignment = .right
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        setUI()
        setLayout()
        setDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods

    func setStyle() {
        backgroundColor = .gray100
        clipsToBounds = true
        layer.cornerRadius = 8
    }
    
    func setUI() {
        addSubviews(textView, placeholderLabel, countLabel)
    }
    
    func setLayout() {
        textView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(39)
        }
        
        placeholderLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.leading.equalToSuperview().offset(18)
        }
        
        countLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(12)
            $0.trailing.equalToSuperview().inset(12)
        }
    }
    
    private func setDelegate() {
        textView.delegate = self
        setTypingAttributesToSuitBodyR16()
        updateUI()
    }
    
    private func updateUI() {
        let count = textView.text.count
        countLabel.text = "\(count)/\(maxCharacterCount)"
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        delegate?.textView(self, didChangeTextCount: count)
    }
    
    func scrollToTop(animated: Bool = false) {
        textView.setContentOffset(.zero, animated: animated)
    }
    
    func configure(text: String) {
        let limitedText = String(text.prefix(maxCharacterCount))
        textView.attributedText = .suit(.body_r_16, text: limitedText)
        setTypingAttributesToSuitBodyR16()
        updateUI()
        scrollToTop()
    }
    
    // MARK: - Helper
    private func setTypingAttributesToSuitBodyR16() {
        let probe = NSAttributedString.suit(.body_r_16, text: " ", lineBreakMode: .byWordWrapping, forceWrap: true)
        let attrs = probe.attributes(at: 0, effectiveRange: nil)
        textView.typingAttributes = attrs
    }
}

// MARK: - Extensions

extension TextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updateUI()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        layer.borderWidth = 1
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        layer.borderWidth = 0
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.contains(where: { $0.isEmoji }) {
            return false
        }
        
        let allowedPunctuation: Set<Character> = [".", ",", "!", "?", "'", "\"", "-", ":", ";", "(", ")", "[", "]", "{", "}", "…"]
        let isAllowed = text.allSatisfy { char in
            char.isLetter || char.isNumber || char.isWhitespace || allowedPunctuation.contains(char)
        }
        
        if !isAllowed {
            return false
        }
        
        guard let currentText = textView.text else { return true }
        
        if let stringRange = Range(range, in: currentText) {
            let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
            return updatedText.count <= maxCharacterCount
        }
        return true
    }
}
