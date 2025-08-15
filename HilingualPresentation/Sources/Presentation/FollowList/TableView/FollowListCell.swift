//
//  FollowListCell.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 8/15/25.
//

import UIKit

final class FollowListCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "FollowListCell"
    
    // MARK: - UI Components
    
    private let profileImg: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .imgProfileNormalIos))
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.gray200.cgColor
        return imageView
    }()
    
    private let nickname: UILabel = {
        let label = UILabel()
        label.font = .suit(.head_b_16)
        label.text = "닉네임"
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private let button = FollowButton()
    
    // MARK: - Life Cycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setStyle()
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setStyle() {
        backgroundColor = .white
        button.configure(state: .following, size: .short)
    }
    
    private func setUI() {
         addSubviews(profileImg, nickname, button)
    }
    
    private func setLayout() {
        profileImg.snp.makeConstraints {
            $0.verticalEdges.equalTo(8)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.size.equalTo(42)
        }
        
        nickname.snp.makeConstraints {
            $0.leading.equalTo(profileImg.snp.trailing).offset(8)
            $0.centerY.equalTo(profileImg)
        }
        
        button.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(profileImg)
        }
    }
}
