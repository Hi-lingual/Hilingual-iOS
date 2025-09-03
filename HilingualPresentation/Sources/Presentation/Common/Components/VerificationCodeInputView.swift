//
//  VerificationCodeInputView.swift
//  HilingualPresentation
//
//  Created by 성현주 on 8/12/25.
//

import UIKit
import SnapKit

final class VerificationCodeInputView: BaseUIView, UIKeyInput, UITextInputTraits {

    // MARK: - Callback
    var onTextChanged: ((String) -> Void)?

    // MARK: - State
    enum State {
        case normal
        case error(String)
    }

    // MARK: - Public
    var text: String { internalText }
    var isComplete: Bool { internalText.count == 6 }

    func setState(_ state: State) {
        currentState = state
        applyStateAppearance()
        refreshBoxes()
    }

    // MARK: - Private State
    private var internalText: String = "" {
        didSet {
            internalText = String(internalText.prefix(6))
            onTextChanged?(internalText)
        }
    }

    private var currentState: State = .normal

    // MARK: - UI Components

    private let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()

    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.spacing = 8
        return stack
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .suit(.caption_r_12)
        label.textColor = .alertRed
        label.numberOfLines = 0
        return label
    }()

    private let hiddenTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.textContentType = .oneTimeCode
        textField.tintColor = .clear
        textField.textColor = .clear
        textField.backgroundColor = .clear
        return textField
    }()

    private var boxViews: [UILabel] = []

    // MARK: - Custom Method

    override func setUI() {
        backgroundColor = .clear

        addSubviews(mainStack, hiddenTextField)
        mainStack.addArrangedSubview(stack)
        mainStack.addArrangedSubview(messageLabel)

        setAction()
        configureBoxes()
        applyStateAppearance()
    }

    override func setLayout() {
        hiddenTextField.snp.makeConstraints {
            $0.size.equalTo(1)
            $0.center.equalToSuperview()
        }
        mainStack.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    private func setAction() {
        hiddenTextField.delegate = self
        hiddenTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)

        let tap = UITapGestureRecognizer(target: self, action: #selector(becomeFirstResponderAction))
        addGestureRecognizer(tap)
    }

    // MARK: - Private Method

    private func configureBoxes() {
        boxViews.forEach { $0.removeFromSuperview() }
        boxViews.removeAll()

        for _ in 0..<6 {
            let label: UILabel = {
                let label = UILabel()
                label.textAlignment = .center
                label.font = .suit(.head_sb_20)
                label.textColor = .label
                label.backgroundColor = .gray100   
                label.layer.cornerRadius = 8
                label.layer.masksToBounds = true
                label.layer.borderWidth = 1
                label.layer.borderColor = UIColor.gray100.cgColor
                return label
            }()
            label.snp.makeConstraints { make in
                make.width.equalTo(50)
                make.height.equalTo(60)
            }
            stack.addArrangedSubview(label)
            boxViews.append(label)
        }

        refreshBoxes()
    }

    private func applyStateAppearance() {
        switch currentState {
        case .normal:
            messageLabel.text = nil
            messageLabel.isHidden = true

            for (idx, label) in boxViews.enumerated() {
                let isFilled = idx < internalText.count
                if isFilled {
                    label.backgroundColor = .white
                    label.layer.borderColor = UIColor.black.cgColor
                    label.layer.borderWidth = 1
                } else {
                    label.backgroundColor = .gray100
                    label.layer.borderColor = UIColor.gray100.cgColor
                    label.layer.borderWidth = 1
                }
            }

        case .error(let message):
            messageLabel.text = message
            messageLabel.isHidden = false
            for label in boxViews {
                label.backgroundColor = .white
                label.layer.borderColor = UIColor.alertRed.cgColor
                label.layer.borderWidth = 1
            }
        }
    }

    // MARK: - Update

    @objc private func textDidChange() {
        let changed = clampAndAssign(from: hiddenTextField.text ?? "")
        if changed, case .error = currentState {
            setState(.normal)
        } else {
            refreshBoxes()
        }
    }

    private func clampAndAssign(from raw: String) -> Bool {
        let prev = internalText
        let filtered = raw.filter { $0.isNumber }
        let clipped = String(filtered.prefix(6))
        if clipped != hiddenTextField.text { hiddenTextField.text = clipped }
        internalText = clipped
        return prev != internalText
    }

    private func refreshBoxes() {
        let chars = Array(internalText)
        for i in 0..<boxViews.count {
            updateBox(boxViews[i], at: i, chars: chars)
        }
    }

    private func updateBox(_ label: UILabel, at index: Int, chars: [Character]) {
        if index < chars.count {
            label.text = String(chars[index])
        } else {
            label.text = ""
        }

        switch currentState {
        case .error:
            label.backgroundColor = .white
            label.layer.borderColor = UIColor.alertRed.cgColor
            label.textColor = .alertRed

        case .normal:
            if index < chars.count {
                label.backgroundColor = .white
                label.layer.borderColor = UIColor.black.cgColor
                label.textColor = .black
            } else {
                label.backgroundColor = .gray100
                label.layer.borderColor = UIColor.gray100.cgColor
                label.textColor = .label  
            }
        }
    }

    // MARK: - UIResponder

    @objc private func becomeFirstResponderAction() { _ = becomeFirstResponder() }

    override func becomeFirstResponder() -> Bool {
        hiddenTextField.becomeFirstResponder()
    }

    override func resignFirstResponder() -> Bool {
        hiddenTextField.resignFirstResponder()
    }

    // MARK: - UIKeyInput

    var hasText: Bool { !internalText.isEmpty }

    func insertText(_ text: String) {
        guard text.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil else { return }
        let new = String((internalText + text).prefix(6))
        hiddenTextField.text = new
        let changed = clampAndAssign(from: new)
        if changed, case .error = currentState {
            setState(.normal)
        } else {
            refreshBoxes()
        }
    }

    func deleteBackward() {
        guard !internalText.isEmpty else { return }
        var new = internalText
        _ = new.popLast()
        hiddenTextField.text = new
        let changed = clampAndAssign(from: new)
        if changed, case .error = currentState {
            setState(.normal)
        } else {
            refreshBoxes()
        }
    }

    // MARK: - UITextInputTraits

    var keyboardType: UIKeyboardType {
        get { .numberPad }
        set { }
    }
}

// MARK: - UITextFieldDelegate

extension VerificationCodeInputView: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        return true
    }
}
