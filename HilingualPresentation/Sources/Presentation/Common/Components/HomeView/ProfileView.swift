//
//  ProfileView.swift
//  HilingualPresentation
//
//  Created by 조영서 on 7/11/25.
//

import UIKit
import SnapKit
import Kingfisher

final class ProfileView: UIView {
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .suit(.head_b_18)
        label.textColor = .white
        return label
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 23
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let totalImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "ic_bubble_16_ios", in: .module, compatibleWith: nil)
        return imageView
    }()
    
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.font = .suit(.caption_m_12)
        label.textColor = .white
        return label
    }()
    
    private let dot: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 1
        return view
    }()
    
    private let streakImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "ic_fire_16_ios", in: .module, compatibleWith: nil)
        return imageView
    }()
    
    private let streakLabel: UILabel = {
        let label = UILabel()
        label.font = .suit(.caption_m_12)
        label.textColor = .white
        return label
    }()
    
    private let profileStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.alignment = .leading
        return stack
    }()
    
    private let statusStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        return stack
    }()
    
    private(set) var alarmButton: UIButton = {
        let button = UIButton()
        button.setImage(
            UIImage(named: "ic_alarm_28_ios", in: .module, compatibleWith: nil),
            for: .normal
        )
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        updateView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        addSubviews(profileImageView, profileStack, alarmButton)
        
        profileStack.addArrangedSubviews(
            nameLabel,
            statusStack)
        
        statusStack.addArrangedSubviews(
            totalImageView,
            totalLabel,
            dot,
            streakImageView,
            streakLabel)
    }
    
    private func setupLayout() {
        
        dot.snp.makeConstraints {
            $0.size.equalTo(2)
        }
        
        profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.width.height.equalTo(46)
        }
        
        profileStack.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView.snp.centerY)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        
        alarmButton.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView.snp.centerY)
            $0.trailing.equalToSuperview().inset(18)
        }
    }
    
    func updateView(
        nickname: String = "닉네임을 입력해주세요",
        profileImageURL: String? = nil,
        totalDiaries: Int = 0,
        streak: Int = 0
    ) {
        nameLabel.text = nickname
        totalLabel.text = "총 \(totalDiaries)편"
        streakLabel.text = "\(streak)일 연속 작성 중"
        
        if let urlString = profileImageURL,
           !urlString.isEmpty,
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
