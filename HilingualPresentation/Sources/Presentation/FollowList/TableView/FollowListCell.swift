//
//  FollowListCell.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 8/15/25.
//

import UIKit

@MainActor
protocol FollowListCellDelegate: AnyObject {
    func followButtonTapped(cell: FollowListCell)
    func profileTapped(cell: FollowListCell)
}

final class FollowListCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "FollowListCell"
    
    weak var delegate: FollowListCellDelegate?
    
    // MARK: - UI Components
    
    private lazy var leftStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [profileImg, nickname])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()
    
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [leftStack, button])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private let profileImg: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .imgProfileNormalIos))
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.gray200.cgColor
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 21
        return imageView
    }()
    
    private(set) var nickname: UILabel = {
        let label = UILabel()
        label.font = .suit(.head_b_16)
        label.text = "닉네임"
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private(set) var button = FollowButton()
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setStyle()
        setUI()
        setLayout()
        setGestureRecognizers()
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setStyle() {
        selectionStyle = .none
        backgroundColor = .white
        button.configure(state: .following)
    }
    
    private func setUI() {
        contentView.addSubview(mainStack)
    }
    
    private func setLayout() {
        profileImg.snp.makeConstraints {
            $0.size.equalTo(42)
        }
        
        mainStack.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        button.snp.makeConstraints {
            $0.width.equalTo(80)
            $0.height.equalTo(33)
        }
    }

    private func setGestureRecognizers() {
        profileImg.isUserInteractionEnabled = true
        nickname.isUserInteractionEnabled = true

        let profileTap = UITapGestureRecognizer(target: self, action: #selector(profileTapped))
        profileImg.addGestureRecognizer(profileTap)

        let nameTap = UITapGestureRecognizer(target: self, action: #selector(profileTapped))
        nickname.addGestureRecognizer(nameTap)
    }
    
    // MARK: - Configure
    
    func configure(with user: UserDisplayable) {
        if !user.profileImg.isEmpty, let profileURL = URL(string: user.profileImg) {
            profileImg.kf.setImage(with: profileURL, placeholder: UIImage(resource: .imgProfileNormalIos))
        } else {
            profileImg.image = UIImage(resource: .imgProfileNormalIos)
        }
        nickname.text = user.nickname
        button.configure(state: user.buttonState)
    }
    
    // MARK: - Action
    
    @objc private func buttonTapped() {
        delegate?.followButtonTapped(cell: self)
    }

    @objc private func profileTapped() {
        delegate?.profileTapped(cell: self)
    }
}

#Preview {
    FollowListCell()
}
