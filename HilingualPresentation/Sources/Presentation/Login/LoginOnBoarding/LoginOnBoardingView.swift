//
//  LoginOnBoardingView.swift
//  HilingualPresentation
//
//  Created by 성현주 on 2/12/26.
//

import UIKit
import SnapKit

final class LoginOnBoardingView: BaseUIView {

    // MARK: - UI Components

    let skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setAttributedTitle(.pretendard(.body_m_14, text: "건너뛰기"), for: .normal)
        button.setTitleColor(.gray400, for: .normal)
        return button
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .hilingualBlack
        let text = "한 줄도, 한국어도, 사진도\n괜찮은 일기 작성"
        let attributedText = NSMutableAttributedString(
            attributedString: .pretendard(.head_sb_20, text: text, lineBreakMode: .byWordWrapping)
        )
        let highlightedRange = (text as NSString).range(of: "일기 작성")
        attributedText.addAttribute(.foregroundColor, value: UIColor.hilingualOrange, range: highlightedRange)
        label.attributedText = attributedText
        return label
    }()

    let previewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "img_onboarding_bottomsheet_2_ios", in: .module, compatibleWith: nil)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let activeIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .hilingualOrange
        view.layer.cornerRadius = 4
        return view
    }()

    private let inactiveIndicator1: UIView = {
        let view = UIView()
        view.backgroundColor = .gray200
        view.layer.cornerRadius = 4
        return view
    }()

    private let inactiveIndicator2: UIView = {
        let view = UIView()
        view.backgroundColor = .gray200
        view.layer.cornerRadius = 4
        return view
    }()

    private let inactiveIndicator3: UIView = {
        let view = UIView()
        view.backgroundColor = .gray200
        view.layer.cornerRadius = 4
        return view
    }()

    private lazy var indicatorStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            inactiveIndicator1,
            activeIndicator,
            inactiveIndicator2,
            inactiveIndicator3
        ])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()

    let nextButton: CTAButton = {
        let button = CTAButton(style: .TextButton("다음"))
        return button
    }()

    // MARK: - Setup

    override func setUI() {
        backgroundColor = .white
        addSubviews(
            skipButton,
            titleLabel,
            previewImageView,
            indicatorStackView,
            nextButton
        )
    }

    override func setLayout() {
        skipButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(12)
            $0.trailing.equalToSuperview().inset(24)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(65)
            $0.leading.trailing.equalToSuperview().inset(24)
        }

        previewImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(28)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(375)
            $0.height.equalTo(376)
        }

        inactiveIndicator1.snp.makeConstraints {
            $0.width.height.equalTo(8)
        }

        inactiveIndicator2.snp.makeConstraints {
            $0.width.height.equalTo(8)
        }

        inactiveIndicator3.snp.makeConstraints {
            $0.width.height.equalTo(8)
        }

        activeIndicator.snp.makeConstraints {
            $0.width.equalTo(20)
            $0.height.equalTo(8)
        }

        indicatorStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(previewImageView.snp.bottom).offset(32)
        }

        nextButton.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(16)
        }
    }
}
