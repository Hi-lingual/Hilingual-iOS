//
//  NotificationSettingView.swift
//  HilingualPresentation
//
//  Created by 성현주 on 8/25/25.
//

import UIKit
import SnapKit

final class NotificationSettingView: BaseUIView {

    // MARK: - UI Components

    let marketingToggle = CustomToggle()
    let feedToggle = CustomToggle()

    private let marketingLabel: UILabel = {
        let label = UILabel()
        label.text = "마케팅 알림"
        label.font = .suit(.body_m_16)
        label.textColor = .black
        return label
    }()

    private let feedLabel: UILabel = {
        let label = UILabel()
        label.text = "피드 알림"
        label.font = .suit(.body_m_16)
        label.textColor = .black
        return label
    }()

    private lazy var marketingRow: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [marketingLabel, marketingToggle])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        return stack
    }()

    private lazy var feedRow: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [feedLabel, feedToggle])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        return stack
    }()

    private lazy var rowsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [marketingRow, feedRow])
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()

    // MARK: - Custom Method

    override func setUI() {
        backgroundColor = .white
        addSubviews(rowsStack)
    }

    override func setLayout() {

        rowsStack.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(32)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        marketingToggle.snp.makeConstraints {
            $0.width.equalTo(52)
            $0.height.equalTo(28)
        }

        feedToggle.snp.makeConstraints {
            $0.width.equalTo(52)
            $0.height.equalTo(28)
        }
    }

    // MARK: - Public fu

    func configure(marketingOn: Bool, feedOn: Bool) {
        marketingToggle.setOn(marketingOn, animated: false)
        feedToggle.setOn(feedOn, animated: false)
    }
}
