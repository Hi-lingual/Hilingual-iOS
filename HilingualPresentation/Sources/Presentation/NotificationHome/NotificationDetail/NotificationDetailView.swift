//
//  NotificationDetailView.swift
//  HilingualPresentation
//
//  Created by 성현주 on 8/26/25.
//

import UIKit

final class NotificationDetailView: BaseUIView {

    // MARK: - UI Components

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .suit(.head_b_20)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .suit(.caption_r_14)
        label.textColor = .gray300
        return label
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()

    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .suit(.body_m_16)
        label.textColor = .gray850
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    override func setUI() {
        addSubviews(titleLabel, dateLabel, contentLabel,separatorView)
    }

    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        separatorView.snp.makeConstraints {
              $0.top.equalTo(dateLabel.snp.bottom).offset(16)
              $0.leading.trailing.equalToSuperview()
              $0.height.equalTo(1)
          }

        contentLabel.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.lessThanOrEqualToSuperview().inset(20)
        }
    }

    // MARK: - Public

    func configure(with model: NotificationDetailModel) {
        titleLabel.text = model.title
        dateLabel.text = model.date
        contentLabel.text = model.content
    }
}
