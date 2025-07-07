//
//  CalendarHeaderView.swift
//  HilingualPresentation
//
//  Created by 조영서 on 7/7/25.
//

import UIKit
import SnapKit

final class CalendarHeaderView: UIView {

    // MARK: - UI Components

    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = .suit(.head_b_18)
        label.text = "2025년 7월"
        label.textColor = .black
        return label
    }()

    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_arrow_down_16_ios", in: .module, compatibleWith: nil)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let monthStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        return stack
    }()

    private let previousButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_arrow_left_20_ios", in: .module, compatibleWith: nil), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()

    private let nextButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_arrow_right_20_ios", in: .module, compatibleWith: nil), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()

    private let buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        return stack
    }()
    
    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupUI() {
        
        monthStack.addArrangedSubview(textLabel)
        monthStack.addArrangedSubview(iconView)
        
        buttonStack.addArrangedSubview(previousButton)
        buttonStack.addArrangedSubview(nextButton)

        addSubview(buttonStack)
        addSubview(monthStack)
    }

    private func setupLayout() {
        monthStack.snp.makeConstraints {
            $0.leading.equalToSuperview()
        }

        buttonStack.snp.makeConstraints {
            $0.trailing.equalToSuperview()
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    CalendarHeaderView()
}
