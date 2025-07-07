//
//  TextField.swift
//  HilingualPresentation
//
//  Created by 성현주 on 7/8/25.
//

import UIKit
import SnapKit

final class TextField: BaseUIView {

    public enum State {
        case normal
        case error(String)
        case success(String)
    }

    // MARK: - Public Properties

    var maxLength: Int = 10 {
        didSet {
            updateCharacterCount()
        }
    }

    var text: String {
        return textField.text ?? ""
    }

    // MARK: - UI Components

    let textField:  UITextField = {
        let textField = UITextField()
        textField.font = .suit(.body_sb_16)
        textField.borderStyle = .none
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.backgroundColor = .gray100
        return textField
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .suit(.caption_r_12)
        label.textColor = .systemRed
        label.numberOfLines = 0
        return label
    }()

    private lazy var characterCountLabel:  UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = "0/\(maxLength)"
        return label
    }()

    private let messageStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.distribution = .equalSpacing
        return stack
    }()

    private let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        updateState(.normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    func setPlaceholder(_ text: String) {
        textField.placeholder = text
    }

    func updateState(_ state: State) {
        switch state {
        case .normal:
            textField.layer.borderColor = UIColor.clear.cgColor
            messageLabel.text = ""
        case .error(let message):
            textField.layer.borderColor = UIColor.systemRed.cgColor
            messageLabel.text = message
            messageLabel.textColor = .systemRed
        case .success(let message):
            textField.layer.borderColor = UIColor.clear.cgColor
            messageLabel.text = message
            messageLabel.textColor = .hilingualBlue
        }
    }

    // MARK: - Custom Methods

    override func setUI() {
        backgroundColor = .clear
        addSubview(mainStack)

        mainStack.addArrangedSubview(textField)
        mainStack.addArrangedSubview(messageStack)

        messageStack.addArrangedSubview(messageLabel)
        messageStack.addArrangedSubview(characterCountLabel)

        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)

        addTextPadding()
    }

    override func setLayout() {
        textField.snp.makeConstraints {
            $0.height.equalTo(54)
        }

        mainStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    // MARK: - Private Methods

    private func setAction() {
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)

    }

    private func updateCharacterCount() {
        characterCountLabel.text = "\(text.count)/\(maxLength)"
    }

    private func addTextPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftView = paddingView
        textField.leftViewMode = .always
    }

    @objc
    private func textDidChange() {
        let current = textField.text ?? ""
        if current.count > maxLength {
            textField.text = String(current.prefix(maxLength))
        }
        updateCharacterCount()
    }
}
