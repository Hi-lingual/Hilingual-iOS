//
//  MypageView.swift
//  HilingualPresentation
//
//  Created by 성현주 on 8/20/25.
//

import UIKit
import SnapKit
import Kingfisher

final class MypageView: BaseUIView {

    // MARK: - Menu Enum

    enum MenuItem {
        case notification
        case blockedUsers
        case support
        case policy
    }

    // MARK: - Public

    var onMenuTap: ((MenuItem) -> Void)?
    var onEditProfileTap: (() -> Void)?

    // MARK: - UI Components

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "마이페이지"
        label.font = .suit(.head_b_18)
        label.textColor = .black
        return label
    }()

    private let profileCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        return view
    }()

    private let menuCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        return view
    }()

    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray200
        imageView.layer.cornerRadius = 30
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.gray200.cgColor
        return imageView
    }()

    let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "내 닉네임"
        label.font = .suit(.head_b_18)
        label.textColor = .black
        return label
    }()

    let editButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_pen_24_ios", in: .module, compatibleWith: nil), for: .normal)
        button.tintColor = .gray400
        return button
    }()

    let feedButton: UIButton = {
        let button = UIButton()
        button.setTitle("나의 피드", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.font = .suit(.body_sb_14)
        button.layer.cornerRadius = 4
        return button
    }()

    let versionLabel: UILabel = {
        let label = UILabel()
        label.text = "버전 정보"
        label.font = .suit(.body_m_14)
        label.textColor = .gray700
        return label
    }()

    private let versionIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_info_24_ios", in: .module, compatibleWith: nil)
        imageView.tintColor = .gray700
        return imageView
    }()

    let versionValueLabel: UILabel = {
        let label = UILabel()
        label.text = "1.01.01"
        label.font = .suit(.caption_r_14)
        label.textColor = .gray400
        return label
    }()

    let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그아웃", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setImage(UIImage(named: "ic_logout_24_ios", in: .module, compatibleWith: nil), for: .normal)
        button.tintColor = .black
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.contentHorizontalAlignment = .leading
        button.semanticContentAttribute = .forceLeftToRight
        return button
    }()

    private let menuItems: [(item: MenuItem, title: String, icon: String)] = [
        (.notification, "알림 설정", "ic_bell_24_ios"),
        (.blockedUsers, "차단한 유저", "ic_block_black_24_ios"),
        (.support, "고객센터", "ic_customer_24_ios"),
        (.policy, "개인정보 처리방침 및 이용약관", "ic_document_24_ios")
    ]

    private var menuRows: [UIControl] = []

    // MARK: - Custom Method

    override func setUI() {
        backgroundColor = .gray100

        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(titleLabel, profileCardView, menuCardView, versionIconView, versionLabel, versionValueLabel, logoutButton)
        profileCardView.addSubviews(profileImageView, nicknameLabel, editButton, feedButton)

        for item in menuItems {
            let row = makeMenuRowView(title: item.title, icon: item.icon) { [weak self] in
                self?.onMenuTap?(item.item)
            }
            menuCardView.addSubview(row)
            menuRows.append(row)
        }

        addGesture()
    }

    override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.leading.equalToSuperview().inset(18)
        }

        profileCardView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        profileImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(12)
            $0.size.equalTo(60)
        }

        nicknameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
            $0.centerY.equalTo(profileImageView)
        }

        editButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalTo(nicknameLabel)
            $0.size.equalTo(24)
        }

        feedButton.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.height.equalTo(37)
            $0.bottom.equalToSuperview().inset(20)
        }

        menuCardView.snp.makeConstraints {
            $0.top.equalTo(profileCardView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        for (index, row) in menuRows.enumerated() {
            row.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(52)
                if index == 0 {
                    $0.top.equalToSuperview()
                } else {
                    $0.top.equalTo(menuRows[index - 1].snp.bottom)
                }
                if index == menuRows.count - 1 {
                    $0.bottom.equalToSuperview()
                }
            }
        }

        versionIconView.snp.makeConstraints {
            $0.top.equalTo(menuCardView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(28)
            $0.size.equalTo(24)
        }

        versionLabel.snp.makeConstraints {
            $0.centerY.equalTo(versionIconView)
            $0.leading.equalTo(versionIconView.snp.trailing).offset(8)
        }

        versionValueLabel.snp.makeConstraints {
            $0.centerY.equalTo(versionLabel)
            $0.trailing.equalToSuperview().inset(28)
        }

        logoutButton.snp.makeConstraints {
            $0.top.equalTo(versionLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(28)
            $0.height.equalTo(44)
            $0.bottom.equalToSuperview().inset(40)
        }
    }

    // MARK: - Private Method

    private func makeMenuRowView(title: String, icon: String, action: @escaping () -> Void) -> UIControl {
        let container = UIControl()

        let iconView = UIImageView(image: UIImage(named: icon, in: .module, compatibleWith: nil))
        iconView.tintColor = .black

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .suit(.body_m_14)
        titleLabel.textColor = .black

        let chevron = UIImageView(image: UIImage(named: "ic_arrow_right_g_24_ios", in: .module, compatibleWith: nil))
        chevron.tintColor = .gray300

        container.addSubviews(iconView, titleLabel, chevron)

        iconView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(iconView.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
        }
        chevron.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
        container.addAction(UIAction { _ in action() }, for: .touchUpInside)
        return container
    }

    private func addGesture() {
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleEditProfileTap))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(imageTapGesture)

        let nicknameTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleEditProfileTap))
        nicknameLabel.isUserInteractionEnabled = true
        nicknameLabel.addGestureRecognizer(nicknameTapGesture)
    }

    //MARK: - Actions

    @objc private func handleEditProfileTap() {
        onEditProfileTap?()
    }
}

//MARK: - Extension

extension MypageView {
    public func configure(nickname: String, profileImageURL: String?) {
        nicknameLabel.text = nickname

        if let urlString = profileImageURL, let url = URL(string: urlString) {
            profileImageView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "img_profile_normal_ios", in: .module, compatibleWith: nil),
                options: [
                    .transition(.fade(0.2)),
                    .cacheOriginalImage
                ]
            )
        } else {
            profileImageView.image = UIImage(named: "img_profile_normal_ios", in: .module, compatibleWith: nil)
        }
    }
}
