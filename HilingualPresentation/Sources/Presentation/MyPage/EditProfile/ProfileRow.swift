//
//  ProfileRow.swift
//  HilingualPresentation
//
//  Created by 성현주 on 8/21/25.
//

import UIKit
import SnapKit

final class ProfileRow: UIView {

    // MARK: - UI Components

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .hilingualBlack
        label.font = .suit(.body_sb_16)
        return label
    }()

    private let valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray500
        label.font = .suit(.body_m_16)
        label.textAlignment = .right
        return label
    }()

    // MARK: - Init

    init(title: String, value: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        valueLabel.text = value
        setupUI()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray200.cgColor
        addSubviews(titleLabel, valueLabel)
    }

    private func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }

        valueLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
    }

    // MARK: - Public Method

    public func setValue(value: String) {
        valueLabel.text = value
    }
}
