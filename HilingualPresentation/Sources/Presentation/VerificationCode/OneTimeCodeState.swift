//
//  OneTimeCodeView.swift
//  HilingualPresentation
//
//  Created by 성현주 on 8/12/25.
//

import UIKit
import SnapKit

final class OneTimeCodeView: BaseUIView, UIKeyInput, UITextInputTraits {

    // MARK: - State
    enum State {
        case normal
        case error(String)
    }

    // MARK: - Public

    var text: String { internalText }
    var isComplete: Bool { internalText.count == 6 }

    /// 상태 변경 (외부에서 호출)
    func setState(_ state: State) {
        currentState = state
        applyStateAppearance()
        refreshBoxes()
    }

    // MARK: - Private State

    private var internalText: String = "" {
        didSet { internalText = String(internalText.prefix(6)) }
    }

    private var currentState: State = .normal

    // MARK: - UI Components

    private let mainStack: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.spacing = 6
        return v
    }()

    private let stack: UIStackView = {
        let v = UIStackView()
        v.axis = .horizontal
        v.alignment = .fill
        v.distribution = .equalSpacing
        v.spacing = 8
        return v
    }()

    private let messageLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 12, weight: .regular)
        l.textColor = .systemRed
        l.numberOfLines = 0
        return l
    }()

    private let hiddenTextField: UITextField = {
        let tf = UITextField()
        tf.keyboardType = .numberPad
        tf.textContentType = .oneTimeCode
        tf.tintColor = .clear
        tf.textColor = .clear
        tf.backgroundColor = .clear
        return tf
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
            $0.size.equalTo(CGSize(width: 1, height: 1))
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
                let l = UILabel()
                l.textAlignment = .center
                l.font = .systemFont(ofSize: 20, weight: .medium)
                l.textColor = .label
                l.backgroundColor = .secondarySystemBackground
                l.layer.cornerRadius = 10
                l.layer.masksToBounds = true
                return l
            }()
            label.snp.makeConstraints { make in
                make.width.equalTo(44)
                make.height.equalTo(52)
            }
            stack.addArrangedSubview(label)
            boxViews.append(label)
        }

        refreshBoxes()
    }

    private func applyStateAppearance() {
        // 메시지 표시
        switch currentState {
        case .normal:
            messageLabel.text = nil
            messageLabel.isHidden = true
        case .error(let message):
            messageLabel.text = message
            messageLabel.isHidden = false
        }

        // 테두리 색 일괄 적용
        let color: CGColor = {
            switch currentState {
            case .normal: return UIColor.systemGray4.cgColor
            case .error:  return UIColor.systemRed.cgColor
            }
        }()
        boxViews.forEach { $0.layer.borderColor = color }
    }

    // MARK: - Update

    @objc private func textDidChange() {
        let didChange = clampAndAssign(from: hiddenTextField.text ?? "")
        if didChange, case .error = currentState {
            // 에러 상태에서 입력이 변경되면 즉시 normal로 복귀
            setState(.normal)
        }
        refreshBoxes()
    }

    /// 숫자만 허용 + 6자리 클램프. 실제 변경 여부 반환.
    @discardableResult
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
            label.layer.borderWidth = 2
        } else {
            label.text = ""
            label.layer.borderWidth = 1
        }
        // borderColor는 applyStateAppearance()에서 일괄 관리
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
        let didChange = clampAndAssign(from: new)
        if didChange, case .error = currentState { setState(.normal) }
        refreshBoxes()
    }

    func deleteBackward() {
        guard !internalText.isEmpty else { return }
        var new = internalText
        _ = new.popLast()
        hiddenTextField.text = new
        let didChange = clampAndAssign(from: new)
        if didChange, case .error = currentState { setState(.normal) }
        refreshBoxes()
    }

    // MARK: - UITextInputTraits

    var keyboardType: UIKeyboardType {
        get { .numberPad }
        set { }
    }
}

// MARK: - UITextFieldDelegate
extension OneTimeCodeView: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        // oneTimeCode 자동 입력 허용
        return true
    }
}
