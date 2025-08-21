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
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
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
    }
    
    // MARK: - Configure
    
    func configure(with user: FeedSearchUser) {
        // profileImg.setImage(with: URL(string: user.profileImg))
        nickname.text = user.nickname
        button.configure(state: user.isFollowing ? .following : .follow, size: .short)
        
        button.removeTarget(nil, action: nil, for: .allEvents)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    // MARK: - Action
    
    @objc private func buttonTapped() {
        delegate?.followButtonTapped(cell: self)
    }
}

#Preview {
    FollowListCell()
}
