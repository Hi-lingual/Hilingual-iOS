////
////  FeedDiaryCell.swift
////  HilingualPresentation
////
////  Created by 조영서 on 8/15/25.
////
//
//import UIKit
//import SnapKit
//import Kingfisher
//
//final class FeedDiaryCell: UITableViewCell {
//
//    // MARK: - UI Components
//
//    private let mainStackView: UIStackView = {
//        let stack = UIStackView()
//        stack.axis = .horizontal
//        stack.spacing = 10
//        stack.alignment = .top
//        return stack
//    }()
//
//    private let profileImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFill
//        imageView.layer.cornerRadius = 21
//        imageView.clipsToBounds = true
//        imageView.layer.borderWidth = 1
//        imageView.layer.borderColor = UIColor.gray200.cgColor
//        return imageView
//    }()
//
//    private let profileStack: UIStackView = {
//        let stack = UIStackView()
//        stack.axis = .horizontal
//        stack.spacing = 2
//        stack.alignment = .center
//        return stack
//    }()
//    
//    private let nameLabel: UILabel = {
//        let label = UILabel()
//        label.font = .suit(.head_b_16)
//        label.textColor = .gray850
//        return label
//    }()
//    
//    private let spacer1: UIView = {
//        let view = UIView()
//        view.backgroundColor = .clear
//        return view
//    }()
//    
//    private let spacer2: UIView = {
//        let view = UIView()
//        view.backgroundColor = .clear
//        return view
//    }()
//
//    private let streakStack: UIStackView = {
//        let stack = UIStackView()
//        stack.axis = .horizontal
//        stack.spacing = 1
//        stack.alignment = .center
//        return stack
//    }()
//
//    private let streakImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFit
//        imageView.image = UIImage(named: "ic_fire_16_ios", in: .module, compatibleWith: nil)
//        return imageView
//    }()
//
//    private let streakLabel: UILabel = {
//        let label = UILabel()
//        label.font = .suit(.caption_r_14)
//        return label
//    }()
//    
//    private let sharedDateLabel: UILabel = {
//        let label = UILabel()
//        label.font = .suit(.caption_m_12)
//        label.textColor = .gray400
//        return label
//    }()
//    
//    private let moreImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFit
//        imageView.image = UIImage(named: "ic_more_24_ios", in: .module, compatibleWith: nil)
//        return imageView
//    }()
//    
//    private let emptyDiaryLabel: UILabel = {
//        let label = UILabel()
//        label.text = "I sent a message to my friend, but she didn’t reply all day. Maybe I said something wrong yesterday? Or maybe she’s just busy. I feel a little lonely today. I know I shouldn’t worry too much, but it’s"
//        label.font = .suit(.body_r_16)
//        label.textColor = .black
//        label.numberOfLines = 5
//        label.textAlignment = .left
//        return label
//    }()
//
//    // MARK: - Init
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setUI()
//        setLayout()
//        configure()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    // MARK: - Setup
//
//    private func setUI() {
//        addSubview(mainStackView)
//
//        mainStackView.addArrangedSubviews(profileImageView, profileStack)
//        
//        profileStack.addArrangedSubviews(nameLabel, streakStack, spacer1, sharedDateLabel,spacer2, moreImageView)
//
//        streakStack.addArrangedSubviews(streakImageView, streakLabel)
//    }
//
//    private func setLayout() {
//        mainStackView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//
//        profileImageView.snp.makeConstraints { make in
//            make.width.height.equalTo(42)
//        }
//        
//        spacer1.snp.makeConstraints { make in
//            make.width.height.equalTo(0)
//        }
//        
//        spacer2.snp.makeConstraints { make in
//            make.width.height.equalTo(81)
//        }
//
//        streakImageView.snp.makeConstraints { make in
//            make.width.height.equalTo(16)
//        }
//        
//        moreImageView.snp.makeConstraints { make in
//            make.width.height.equalTo(24)
//        }
//    }
//
//    // MARK: - Public
//
//    // 프로필 정보 갱신
//    func configure(
//        nickname: String = "밍",
//        profileImageURL: String? = nil,
//        follower: Int = 0,
//        following: Int = 0,
//        streak: Int = 0
//    ) {
//        nameLabel.text = nickname
//
//        followerCountLabel.text = "\(follower)"
//        followingCountLabel.text = "\(following)"
//
//        let streakText = streak > 0 ? "\(streak)" : "0"
//        streakLabel.text = streakText
//        streakLabel.textColor = streak > 0 ? .hilingualOrange : .gray400
//
//        if let urlString = profileImageURL,
//           !urlString.isEmpty,
//           let url = URL(string: urlString) {
//            profileImageView.kf.setImage(with: url)
//        } else {
//            profileImageView.image = UIImage(
//                named: "img_profile_normal_ios",
//                in: .module,
//                compatibleWith: nil
//            )
//        }
//    }
//}
//
////#Preview {
////    FeedDiaryCell()
////}
