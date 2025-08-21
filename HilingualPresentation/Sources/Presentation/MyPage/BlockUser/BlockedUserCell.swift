//
//  BlockedUserCell.swift
//  HilingualPresentation
//
//  Created by 성현주 on 8/21/25.
//

import UIKit
import SnapKit
import Combine

final class BlockedUserCell: UITableViewCell {

    static let identifier = "BlockedUserCell"

    // MARK: - UI

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

    // MARK: - Combine

    private var cancellables = Set<AnyCancellable>()
    var unblockTapped = PassthroughSubject<Int, Never>()

    private var userId: Int?

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setLayout()
        addAction()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI 설정

extension BlockedUserCell {

    private func setUI() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(unblockButton)
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
            $0.trailing.equalToSuperview().inset(40)
            $0.centerY.equalToSuperview()
        }
    }

    private func addAction() {
        unblockButton.addTarget(self, action: #selector(didTapUnblock), for: .touchUpInside)
    }

    @objc private func didTapUnblock() {
        guard let id = userId else { return }
        unblockTapped.send(id)
    }
}

// MARK: - Configure

extension BlockedUserCell {

    func configure(with user: BlockedUserModel) {
        nicknameLabel.text = user.nickname
        profileImageView.image = UIImage(named: user.profileImg) ?? UIImage(resource: .imgProfileNormalIos)
        userId = user.userId

        unblockButton.configure(state: .unblock, size: .short)
    }
}
