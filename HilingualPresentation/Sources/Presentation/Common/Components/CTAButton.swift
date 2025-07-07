//
//  CTAButton.swift
//  HilingualPresentation
//
//  Created by 조영서 on 7/5/25.
//

import UIKit
import SnapKit

enum CTAButtonStyle {
    case TextButton(String)
    case IconTextButton(iconName: String, text: String)
}

final class CTAButton: UIButton {
    
    // MARK: - Properties
    
    private var autoBackground: Bool = false
    
    // MARK: - UI Components
    
    private let stackView = UIStackView()
    private let iconView = UIImageView()
    private let textLabel = UILabel()
    
    // MARK: - Lifecycle
    
    override var isEnabled: Bool {
        didSet {
            if autoBackground {
                updateBackgroundColor()
            }
        }
    }

    init(style: CTAButtonStyle, autoBackground: Bool = false, isEnabled: Bool? = nil) {
        super.init(frame: .zero)
        self.autoBackground = autoBackground
        setupStyle()
        setupLayout()
        configure(with: style)
        
        self.isEnabled = autoBackground ? false : true
        
        if autoBackground {
            updateBackgroundColor()
        } else {
            backgroundColor = .hilingualBlack
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setupLayout() {
        snp.makeConstraints {
            $0.height.equalTo(56)
        }
    }
    
    private func setupStyle() {
        layer.cornerRadius = 8
        clipsToBounds = true
        
        textLabel.textColor = .white
        textLabel.font = .suit(.body_sb_16)
        
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
    }
    
    private func configure(with style: CTAButtonStyle) {
        switch style {
        case .TextButton(let text):
            setupTextLabel(text)
            
        case .IconTextButton(let iconName, let text):
            setupStackView(iconName: iconName, text: text)
        }
    }

    private func setupTextLabel(_ text: String) {
        textLabel.text = text
        addSubview(textLabel)
        textLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    private func setupStackView(iconName: String, text: String) {
        iconView.image = UIImage(named: iconName, in: .module, compatibleWith: nil)
        iconView.contentMode = .scaleAspectFit
        iconView.snp.makeConstraints {
            $0.width.height.equalTo(16)
        }

        textLabel.text = text
        stackView.addArrangedSubview(iconView)
        stackView.addArrangedSubview(textLabel)
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    // MARK: - Private Methods
    
    private func updateBackgroundColor() {
        backgroundColor = isEnabled ? .hilingualBlack : .gray300
    }
}
