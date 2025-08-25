//
//  FollowListCell.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 8/15/25.
//

import UIKit

final class NotificationCell: UITableViewCell {

    static let identifier = "NotificationCell"

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .suit(.body_sb_14)
        label.textColor = .gray400
        label.numberOfLines = 2
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .suit(.caption_r_12)
        label.textColor = .gray300
        return label
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: NotificationModel) {
        messageLabel.text = model.title
        dateLabel.text = model.publishedAt
    }

    private func setUI() {
        contentView.addSubviews(messageLabel, dateLabel)
    }

    private func setLayout() {
        messageLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        dateLabel.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(12)
        }
    }
}
