//
//  ProfileView.swift
//  HilingualPresentation
//
//  Created by 조영서 on 7/11/25.
//

import UIKit
import SnapKit

final class ProfileView: UIView {

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "하링이"
        label.font = .suit(.head_b_18)
        label.textColor = .white
        return label
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 23
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "img_profile_normal_ios", in: .module, compatibleWith: nil)
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
        label.text = "총 15편"
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
        label.text = "6일 연속 작성 중"
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

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {

        addSubviews(profileImageView, profileStack)
        
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
            $0.size.equalTo(CGSize(width: 2, height: 2))
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
            $0.width.height.equalTo(46)
        }
        
        profileStack.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView.snp.centerY)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(16)
            $0.bottom.equalToSuperview()
        }
    }
}

#Preview {
    ProfileView()
}
