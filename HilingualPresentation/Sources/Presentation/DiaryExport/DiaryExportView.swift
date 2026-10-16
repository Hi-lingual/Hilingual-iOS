//
//  DiaryExportView.swift
//  HilingualPresentation
//
//  Created by 진소은 on 10/16/26.
//

import UIKit
import SnapKit

final class DiaryExportView: BaseUIView {

    // MARK: - Properties

    var onTopicToggleChanged: ((Bool) -> Void)?

    // MARK: - UI Components

    private let topicRowView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private let topicLabel: UILabel = {
        let label = UILabel()
        label.text = "주제 포함하기"
        label.font = .pretendard(.body_r_16)
        label.textColor = .black
        return label
    }()

    private let topicToggle: CustomToggle = {
        let toggle = CustomToggle()
        toggle.setOn(true, animated: false)
        return toggle
    }()

    private let cardView = DiaryExportCardView()

    private lazy var leftBinderCircles: [UIView] = (0..<3).map { _ in Self.makeBinderCircle() }
    private lazy var rightBinderCircles: [UIView] = (0..<3).map { _ in Self.makeBinderCircle() }
    private lazy var leftBinderCapsules: [UIView] = (0..<3).map { _ in Self.makeBinderCapsule() }
    private lazy var rightBinderCapsules: [UIView] = (0..<3).map { _ in Self.makeBinderCapsule() }

    // MARK: - setUI

    override func setUI() {
        backgroundColor = .gray100
        addSubviews(topicRowView, cardView)
        topicRowView.addSubviews(topicLabel, topicToggle)

        (leftBinderCircles + rightBinderCircles).forEach { addSubview($0) }
        (leftBinderCapsules + rightBinderCapsules).forEach { addSubview($0) }

        topicToggle.addTarget(self, action: #selector(handleToggleChanged), for: .valueChanged)
    }

    override func setLayout() {
        topicRowView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
        }

        topicLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }

        topicToggle.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(12)
            $0.width.equalTo(52)
            $0.height.equalTo(28)
        }

        cardView.snp.makeConstraints {
            $0.top.equalTo(topicRowView.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        for i in 0..<3 {
            let offset: CGFloat = 20 + CGFloat(i) * (14 + 3)

            leftBinderCircles[i].snp.makeConstraints {
                $0.leading.equalTo(cardView.snp.leading).offset(offset)
                $0.top.equalTo(cardView.snp.top)
                $0.size.equalTo(14)
            }
            rightBinderCircles[i].snp.makeConstraints {
                $0.trailing.equalTo(cardView.snp.trailing).offset(-offset)
                $0.top.equalTo(cardView.snp.top)
                $0.size.equalTo(14)
            }
            leftBinderCapsules[i].snp.makeConstraints {
                $0.centerX.equalTo(leftBinderCircles[i])
                $0.bottom.equalTo(cardView.snp.top).offset(12)
                $0.width.equalTo(10)
                $0.height.equalTo(20)
            }
            rightBinderCapsules[i].snp.makeConstraints {
                $0.centerX.equalTo(rightBinderCircles[i])
                $0.bottom.equalTo(cardView.snp.top).offset(12)
                $0.width.equalTo(10)
                $0.height.equalTo(20)
            }
        }
    }

    private static func makeBinderCircle() -> UIView {
        let view = UIView()
        view.backgroundColor = .gray100
        view.layer.cornerRadius = 7
        view.isUserInteractionEnabled = false
        return view
    }

    private static func makeBinderCapsule() -> UIView {
        let view = UIView()
        view.backgroundColor = .gray200
        view.layer.cornerRadius = 5
        view.isUserInteractionEnabled = false
        return view
    }

    // MARK: - Configure

    func configure(
        image: String?,
        originalText: String,
        highlightText: String,
        diffRanges: [HighlightTextView.DiffRange],
        isHighlightingEnabled: Bool
    ) {
        cardView.configure(
            image: image,
            originalText: originalText,
            highlightText: highlightText,
            diffRanges: diffRanges,
            isHighlightingEnabled: isHighlightingEnabled
        )
    }

    func setTopic(_ topic: String) {
        cardView.setTopic(topic)
    }

    func setDate(_ date: String) {
        cardView.setDate(date)
    }

    // MARK: - Actions

    @objc private func handleToggleChanged() {
        let isOn = topicToggle.isOn
        cardView.setTopicVisible(isOn)
        onTopicToggleChanged?(isOn)
    }
}
