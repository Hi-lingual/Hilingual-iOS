//
//  CTAButton.swift
//  HilingualPresentation
//
//  Created by 조영서 on 7/5/25.
//

import UIKit
import SnapKit

enum CTAButtonStyle {
    case enabledText(String)                      // isEnabled 따라 배경색 변경
    case staticText(String)                       // 검정 배경 고정 + 텍스트
    case staticIconText(iconName: String, text: String) // 검정 배경 고정 + 아이콘 + 텍스트
}

final class CTAButton: UIButton {
    
    private let stackView = UIStackView()
    private let iconView = UIImageView()
    private let textLabel = UILabel()
    private var autoBackground: Bool = false

    override var isEnabled: Bool {
        didSet {
            if autoBackground {
                updateBackgroundColor()
            }
        }
    }

    convenience init(style: CTAButtonStyle) {
        self.init(frame: .zero)
        configure(with: style)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
        snp.makeConstraints { make in
            make.height.equalTo(56)
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStyle()
        snp.makeConstraints { make in
            make.height.equalTo(56)
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
        case .enabledText(let text):
            autoBackground = true
            textLabel.text = text
            addSubview(textLabel)
            textLabel.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            updateBackgroundColor()
            isEnabled = false

        case .staticText(let text):
            autoBackground = false
            textLabel.text = text
            addSubview(textLabel)
            textLabel.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            backgroundColor = .hilingualBlack

        case .staticIconText(let iconName, let text):
            autoBackground = false
            iconView.image = UIImage(named: iconName, in: .module, compatibleWith: nil)
            iconView.contentMode = .scaleAspectFit
            iconView.snp.makeConstraints { make in
                make.width.height.equalTo(16)
            }

            textLabel.text = text

            stackView.addArrangedSubview(iconView)
            stackView.addArrangedSubview(textLabel)
            addSubview(stackView)
            stackView.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }

            backgroundColor = .hilingualBlack
        }
    }

    private func updateBackgroundColor() {
        backgroundColor = isEnabled ? .hilingualBlack : .gray300
    }
}
