//
//  BlockedUserCell.swift
//  HilingualPresentation
//
//  Created by 성현주 on 8/21/25.
//

import UIKit
import SnapKit

final class BlockedUserCell: UITableViewCell {

    static let identifier = "BlockedUserCell"

    var onUnblockTapped: ((Int) -> Void)?

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray100
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()

    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .suit(.body_b_14)
        label.textColor = .gray400
        return label
    }()

    private let unblockButton = FollowButton()

    private var userId: Int?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setLayout()
        unblockButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func didTapButton() {
        guard let id = userId else { return }
        onUnblockTapped?(id)
    }

    func configure(with user: BlockedUserModel) {
        nicknameLabel.text = user.nickname
        profileImageView.image = UIImage(named: user.profileImg) ?? UIImage(resource: .imgProfileNormalIos)
        userId = user.userId

        unblockButton.configure(state: user.buttonState)
    }

    private func setUI() {
        contentView.addSubviews(profileImageView, nicknameLabel, unblockButton)
    }

    private func setLayout() {
        profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(40)
        }

        nicknameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
        }

        unblockButton.snp.makeConstraints {
            $0.width.equalTo(80)
            $0.height.equalTo(33)
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
    }
}
