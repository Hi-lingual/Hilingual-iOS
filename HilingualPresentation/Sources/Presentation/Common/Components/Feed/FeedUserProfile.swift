//
//  FeedUserProfile.swift
//  HilingualPresentation
//
//  Created by 조영서 on 8/15/25.
//

import UIKit
import SnapKit
import Kingfisher

final class FeedUserProfile: UIView {

    // MARK: - Callbacks

    var onFollowSectionTapped: (() -> Void)?

    // MARK: - UI Components

    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .center
        return stack
    }()

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.gray200.cgColor
        return imageView
    }()

    private let profileStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        return stack
    }()

    private let profileSpacer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.head_sb_18)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private let followStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 2
        stack.alignment = .center
        return stack
    }()

    private let followerCountLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body_m_14)
        label.textColor = .gray400
        label.textAlignment = .left
        return label
    }()

    private let followerTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body_r_14)
        label.textColor = .gray400
        label.text = "팔로워"
        label.textAlignment = .left
        return label
    }()

    private let followSpacer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    private let followingCountLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body_m_14)
        label.textColor = .gray400
        label.textAlignment = .left
        return label
    }()

    private let followingTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body_r_14)
        label.textColor = .gray400
        label.text = "팔로잉"
        label.textAlignment = .left
        return label
    }()

    private let streakStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 1
        stack.alignment = .center
        return stack
    }()

    private let streakImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "ic_fire_16_ios", in: .module, compatibleWith: nil)
        return imageView
    }()

    private let streakLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body_r_14)
        label.textAlignment = .left
        return label
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setUI() {
        addSubview(mainStackView)

        mainStackView.addArrangedSubviews(profileImageView, profileStack)
        
        profileStack.addArrangedSubviews(nameLabel, followStack, profileSpacer, streakStack)

        followStack.addArrangedSubviews(followerTitleLabel, followerCountLabel, followSpacer, followingTitleLabel, followingCountLabel)

        let followTapGesture = UITapGestureRecognizer(target: self, action: #selector(followSectionTapped))
        followStack.isUserInteractionEnabled = true
        followStack.addGestureRecognizer(followTapGesture)

        streakStack.addArrangedSubviews(streakImageView, streakLabel)
    }

    private func setLayout() {
        mainStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        profileImageView.snp.makeConstraints {
            $0.size.equalTo(60)
        }
        
        profileSpacer.snp.makeConstraints {
            $0.size.equalTo(0)
        }

        followSpacer.snp.makeConstraints {
            $0.size.equalTo(2)
        }

        streakImageView.snp.makeConstraints {
            $0.size.equalTo(16)
        }
    }

    //MARK: - Action

    @objc private func followSectionTapped() {
        onFollowSectionTapped?()
    }

    // MARK: - Public

    // 프로필 정보 갱신
    func configure(
        nickname: String = "이름을 입력해주세요",
        profileImageURL: String? = nil,
        follower: Int = 0,
        following: Int = 0,
        streak: Int = 0
    ) {
        nameLabel.attributedText = .pretendard(
            .head_sb_18,
            text: nickname
        )

        followerCountLabel.text = "\(follower)"
        followingCountLabel.text = "\(following)"
        
        let streakText = streak > 0 ? "\(streak)일 연속 작성 중" : "0일 연속 작성 중"
        streakLabel.text = streakText
        streakLabel.textColor = streak > 0 ? .hilingualOrange : .gray400
        
        if let urlString = profileImageURL,
           !urlString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
           let url = URL(string: urlString) {
            profileImageView.kf.setImage(with: url)
        } else {
            profileImageView.image = UIImage(
                named: "img_profile_normal_ios",
                in: .module,
                compatibleWith: nil
            )
        }
    }
}
