//
//  FollowListCell.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 8/15/25.
//

import UIKit

final class NotificationCell: UITableViewCell {

    static let identifier = "NotificationCell"

    // MARK: - UI Components

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body_m_16)
        label.textColor = .hilingualBlack
        label.numberOfLines = 2
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body_r_14)
        label.textColor = .gray300
        return label
    }()

    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_arrow_right_g_24_ios", in: .module, compatibleWith: nil)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure

    func configure(with model: NotificationModel) {
        messageLabel.attributedText = makeBoldUserNameText(from: model.title)
        dateLabel.text = model.publishedAt
        contentView.backgroundColor = model.isRead ? .white : .gray100
    }

    // MARK: - UI Setup

    private func setUI() {
        contentView.addSubviews(messageLabel, dateLabel, arrowImageView)
    }

    private func setLayout() {
        messageLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalTo(arrowImageView.snp.leading).offset(-4)
        }

        dateLabel.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(8)
            $0.leading.equalTo(messageLabel)
            $0.bottom.equalToSuperview().inset(20)
        }

        arrowImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
            $0.size.equalTo(24)
        }
    }

    // MARK: - Private Methods

    private func makeBoldUserNameText(from text: String) -> NSAttributedString {
        let attributed = NSMutableAttributedString(string: text)
        if let range = text.range(of: "이 당신") {
            let nameRange = NSRange(text.startIndex..<range.lowerBound, in: text)
            attributed.addAttribute(.font, value: UIFont.pretendard(.head_sb_16), range: nameRange)
        }
        return attributed
    }
}
