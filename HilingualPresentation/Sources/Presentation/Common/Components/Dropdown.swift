//
//  Dropdown.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 7/9/25.
//

import UIKit

final class Dropdown: UIView {

    // MARK: - Properties

    private var isExpanded = false
    private var isKorean = false
    private var onToggleAction: (() -> Void)?

    // api로 넣어줄 데이터
    var topicEn: String? {
        didSet {
            updateLabel()
        }
    }

    var topicKor: String? {
        didSet {
            updateLabel()
        }
    }

    // MARK: - UI Components

    private let dropdownBackgroundStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.backgroundColor = .gray100
        return stack
    }()

    private let dropdownHeaderStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.backgroundColor = .gray100
        return stack
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body_r_14)
        label.text = "오늘의 추천 주제 참고하기"
        label.textColor = .gray700
        return label
    }()

    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .icArrowDownGray20Ios)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray400
        return imageView
    }()

    private let tapButton = UIButton()

    private let dropdownContentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.backgroundColor = .white
        stack.layer.cornerRadius = 8
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        stack.isHidden = true
        return stack
    }()

    private let topicEnLabel: UILabel = {
        let label = UILabel()
        label.attributedText = .pretendard(.body_m_16, text: "What surprised you today?")
        label.textColor = .gray700
        label.numberOfLines = 3
        return label
    }()

    private let changeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .icChange20Ios), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .gray300
        return button
    }()

    // MARK: - LifeCycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
        setUI()
        setLayout()
        setActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods

    private func setStyle() {
        backgroundColor = UIColor.gray100
        layer.cornerRadius = 8
        clipsToBounds = true
    }

    private func setUI() {
        addSubviews(dropdownBackgroundStack, tapButton)

        dropdownBackgroundStack.addArrangedSubviews(dropdownHeaderStack, dropdownContentStack)

        dropdownHeaderStack.addArrangedSubviews(titleLabel, arrowImageView)
        dropdownContentStack.addArrangedSubviews(topicEnLabel, changeButton)
    }

    private func setLayout() {
        dropdownBackgroundStack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(12)
        }

        tapButton.snp.makeConstraints {
            $0.edges.equalTo(dropdownHeaderStack)
        }

        arrowImageView.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(12)
            $0.size.equalTo(20)
        }

        dropdownContentStack.snp.makeConstraints {
            $0.top.equalTo(dropdownHeaderStack.snp.bottom).offset(16)
        }

        changeButton.snp.makeConstraints {
            $0.size.equalTo(20)
        }

        dropdownContentStack.setCustomSpacing(12, after: topicEnLabel)
    }

    // MARK: - Actions

    private func setActions() {
        tapButton.addTarget(self, action: #selector(toggleDropdown), for: .touchUpInside)
        changeButton.addTarget(self, action: #selector(changeTopicText), for: .touchUpInside)
    }

    @objc private func toggleDropdown() {
        isExpanded.toggle()
        dropdownContentStack.isHidden = !isExpanded
        arrowImageView.image = UIImage(resource: isExpanded ? .icArrowUp20Ios : .icArrowDownGray20Ios)
        onToggleAction?()
    }

    @objc private func changeTopicText() {
        isKorean.toggle()
        updateLabel()
    }

    private func updateLabel() {
        let text = isKorean ? (topicKor ?? "What surprised you today?") : (topicEn ?? "What surprised you today?")
        topicEnLabel.attributedText = .pretendard(.body_m_16, text: text)
    }

    func configure(kor: String?, en: String?) {
        self.topicKor = kor
        self.topicEn = en
        updateLabel()
    }

    // MARK: - Public Methods
    func addDropdownToggleAction(_ action: @escaping () -> Void) {
        self.onToggleAction = action
    }
}

// MARK: - Preview

#Preview {
    let dropdown = Dropdown()
    return dropdown
}
