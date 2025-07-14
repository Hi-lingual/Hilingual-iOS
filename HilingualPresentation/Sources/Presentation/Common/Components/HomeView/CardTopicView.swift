//
//  CardTopicView.swift
//  HilingualPresentation
//
//  Created by 조영서 on 7/10/25.
//

import UIKit
import SnapKit

final class CardTopicView: UIView {
    
    // MARK: - Callback

    var onTapWriteDiary: (() -> Void)?

    // MARK: - UI Components

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘의 추천 주제"
        label.font = .suit(.caption_m_12)
        label.textColor = .gray500
        label.numberOfLines = 2
        return label
    }()

    private let iconButton: UIButton = {
        let button = UIButton()
        let image = UIImage(
            named: "ic_change_20_ios",
            in: .module,
            compatibleWith: nil
        )
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()

    private let topicStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        return stack
    }()

    private let topicKorLabel: UILabel = {
        let label = UILabel()
        label.font = .suit(.body_sb_16)
        label.textColor = .gray700
        label.numberOfLines = 2
        return label
    }()

    private let topicEnLabel: UILabel = {
        let label = UILabel()
        label.font = .suit(.body_sb_16)
        label.textColor = .gray700
        label.numberOfLines = 2
        return label
    }()

    private let cardStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 4
        stack.backgroundColor = .gray100
        stack.layer.cornerRadius = 8
        return stack
    }()
        
    private let diaryAddButton = CTAButton(style: .IconTextButton(iconName: "ic_plus_16_ios", text: "일기 작성하기"))

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        addTargets()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup

    private func setupUI() {
        backgroundColor = .white

        iconButton.addTarget(
            self,
            action: #selector(didTapChangeTopic),
            for: .touchUpInside
        )

        topicStack.addArrangedSubviews(
            titleLabel,
            iconButton
        )

        cardStack.addArrangedSubviews(
            topicStack,
            topicEnLabel,
            topicKorLabel
        )

        topicKorLabel.isHidden = true
        
        cardStack.isLayoutMarginsRelativeArrangement = true
        cardStack.layoutMargins = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)

        addSubviews(cardStack, diaryAddButton)
    }

    private func setupLayout() {
        
        iconButton.snp.makeConstraints {
            $0.width.height.equalTo(20)
        }

        topicStack.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.height.equalTo(28)
        }

        cardStack.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        diaryAddButton.snp.makeConstraints {
            $0.top.equalTo(cardStack.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Actions

    private func addTargets() {
            iconButton.addTarget(
                self,
                action: #selector(didTapChangeTopic),
                for: .touchUpInside
            )

            diaryAddButton.addTarget(
                self,
                action: #selector(didTapWriteDiary),
                for: .touchUpInside
            )
        }
    
    @objc private func didTapChangeTopic() {
        let isEnglishVisible = !topicEnLabel.isHidden
        topicEnLabel.isHidden = isEnglishVisible
        topicKorLabel.isHidden = !isEnglishVisible
    }
    
    @objc private func didTapWriteDiary() {
            onTapWriteDiary?()
        }
    
    // MARK: - Configuration
    
    func configure(kor: String? = nil, en: String? = nil) {
        topicKorLabel.text = kor ?? "한글 주제 아직 없지롱"
        topicEnLabel.text = en ?? "Bringing up the English topic"
    }
}

#Preview {
    let view = CardTopicView()
    view.configure(kor: nil, en: nil)
    return view
}
