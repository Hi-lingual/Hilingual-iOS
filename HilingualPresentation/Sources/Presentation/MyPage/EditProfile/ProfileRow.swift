//
//  ProfileRow.swift
//  HilingualPresentation
//
//  Created by 성현주 on 8/21/25.
//

import UIKit
import SnapKit

final class ProfileRow: UIView {

    enum RowType {
        case none
        case editable
    }

    // MARK: - Properties

    private let type: RowType

    // MARK: - UI Components

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .hilingualBlack
        label.font = .pretendard(.body_m_16)
        return label
    }()

    private let valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray500
        label.font = .pretendard(.body_m_16)
        label.textAlignment = .right
        return label
    }()

    private let editImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_pen_24_ios", in: .module, compatibleWith: nil)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var trailingStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: trailingViews)
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()

    private var trailingViews: [UIView] {
        switch type {
        case .none:
            return [valueLabel]
        case .editable:
            return [valueLabel, editImageView]
        }
    }

    // MARK: - Init

    init(title: String, value: String, type: RowType = .none) {
        self.type = type
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
        addSubviews(titleLabel, trailingStackView)
    }

    private func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }

        if case .editable = type {
            editImageView.snp.makeConstraints {
                $0.size.equalTo(24)
            }
        }

        trailingStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(12)
        }
    }

    // MARK: - Public Method

    public func setValue(value: String) {
        valueLabel.text = value
    }
}
