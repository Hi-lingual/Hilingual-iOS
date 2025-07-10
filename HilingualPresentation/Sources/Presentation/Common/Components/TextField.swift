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
        case wait
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

    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private let rightStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()

    private lazy var rightContainerView: UIView = {
        let view = UIView()
        view.addSubview(rightStackView)
        rightStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(14)
        }
        return view
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
        textField.attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [
                .foregroundColor: UIColor.gray400,
                .font: UIFont.suit(.body_m_16)
            ]
        )
    }

    func updateState(_ state: State) {
        switch state {
        case .normal:
            textField.layer.borderColor = UIColor.clear.cgColor
            messageLabel.text = ""
            stopLoading()

        case .error(let message):
            textField.layer.borderColor = UIColor.systemRed.cgColor
            messageLabel.text = message
            messageLabel.textColor = .systemRed
            stopLoading()

        case .success(let message):
            textField.layer.borderColor = UIColor.clear.cgColor
            messageLabel.text = message
            messageLabel.textColor = .hilingualBlue
            stopLoading()

        case .wait:
            textField.layer.borderColor = UIColor.clear.cgColor
            messageLabel.text = ""
            startLoading()
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

        rightStackView.addArrangedSubview(loadingIndicator)

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

    private func startLoading() {
        loadingIndicator.startAnimating()
        textField.rightView = rightContainerView
        textField.rightViewMode = .always
    }

    private func stopLoading() {
        loadingIndicator.stopAnimating()
        textField.rightView = nil
        textField.rightViewMode = .never
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
