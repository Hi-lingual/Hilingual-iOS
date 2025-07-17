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
            $0.height.equalTo(58)
        }
    }
    
    private func setupStyle() {
            layer.cornerRadius = 8
            clipsToBounds = true

            titleLabel?.font = .suit(.body_sb_16)
            setTitleColor(.white, for: .normal)
            imageView?.contentMode = .scaleAspectFit

            contentHorizontalAlignment = .center
            semanticContentAttribute = .forceLeftToRight
        
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        }

        private func configure(with style: CTAButtonStyle) {
            switch style {
            case .TextButton(let text):
                setTitle(text, for: .normal)
                setImage(nil, for: .normal)

            case .IconTextButton(let iconName, let text):
                setTitle(text, for: .normal)

                //아이콘 터치 이벤트 무효화 위해서
                guard let image = UIImage(named: iconName, in: .module, compatibleWith: nil) else { return }

                setImage(image, for: .normal)
                setImage(image, for: .highlighted)
                setImage(image, for: .selected)
                setImage(image, for: .disabled)
            }
        }
    
    // MARK: - Private Methods
    
    private func updateBackgroundColor() {
        backgroundColor = isEnabled ? .hilingualBlack : .gray300
    }
}
