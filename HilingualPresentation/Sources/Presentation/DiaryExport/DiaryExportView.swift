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

    // MARK: - setUI

    override func setUI() {
        backgroundColor = .gray100
        addSubviews(topicRowView, cardView)
        topicRowView.addSubviews(topicLabel, topicToggle)

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
