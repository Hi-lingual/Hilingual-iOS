//
//  TextView.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 7/5/25.
//

import UIKit

final class TextView: UIView {
    
    // MARK: - Properties
    
    var maxCharacterCount: Int = 1000
    var onTextCountChanged: ((Int) -> Void)?
    
    // MARK: - UI Components
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .gray100
        textView.font = .suit(.body_r_16)
        textView.textColor = .black
        textView.isScrollEnabled = true
        textView.layer.borderColor = UIColor.hilingualBlack.cgColor
        return textView
    }()
    
    private var placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = .suit(.body_r_16)
        label.textColor = .gray400
        label.text = "What’s been going on today?"
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
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(18)
        }
        
        countLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(12)
            $0.trailing.equalToSuperview().inset(12)
        }
    }
    
    private func setDelegate() {
        textView.delegate = self
        updateUI()
    }
    
    private func updateUI() {
        let count = textView.text.count
        countLabel.text = "\(count)/\(maxCharacterCount)"
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        onTextCountChanged?(count)
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
        guard let currentText = textView.text else { return true }
        
        if let stringRange = Range(range, in: currentText) {
            let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
            return updatedText.count <= maxCharacterCount
        }
        return true
    }
}


// MARK: - PreView

@available(iOS 17.0, *)
fileprivate final class PreviewViewController: UIViewController {
    
    private let countDisplayLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let customTextView = TextView()
        view.addSubview(customTextView)
        customTextView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(343)
            $0.height.equalTo(292)
        }
        
        countDisplayLabel.text = "현재 글자 수: 0"
        view.addSubview(countDisplayLabel)
        countDisplayLabel.snp.makeConstraints {
            $0.top.equalTo(customTextView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        customTextView.onTextCountChanged = { [weak self] count in
            self?.countDisplayLabel.text = "현재 글자 수: \(count)"
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

@available(iOS 17.0, *)
#Preview {
    PreviewViewController()
}
