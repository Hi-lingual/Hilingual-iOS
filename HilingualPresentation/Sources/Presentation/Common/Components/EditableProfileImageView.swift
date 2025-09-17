//
//  EditableProfileImageView.swift
//  HilingualPresentation
//
//  Created by 성현주 on 8/21/25.
//


import UIKit
import SnapKit
import Kingfisher

final class EditableProfileImageView: UIView {

    // MARK: - UI Components

    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "img_profile_normal_ios", in: .module, compatibleWith: nil)
        imageView.layer.cornerRadius = 60
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .gray100
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.gray200.cgColor
        return imageView
    }()

    let editButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_camera_20_ios", in: .module, compatibleWith: nil), for: .normal)
        button.backgroundColor = .gray100
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.1
        button.layer.shadowRadius = 2
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        return button
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup

    private func setUI() {
        addSubview(profileImageView)
        addSubview(editButton)
    }

    private func setLayout() {
        profileImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        editButton.snp.makeConstraints {
            $0.size.equalTo(32)
            $0.bottom.trailing.equalToSuperview().inset(2)
        }
    }

    // MARK: - Layout Update

    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.layer.cornerRadius = bounds.width / 2
    }
}

extension EditableProfileImageView {
    public func setImage(urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            profileImageView.image = UIImage(named: "img_profile_normal_ios", in: .module, compatibleWith: nil)
            return
        }

        profileImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "img_profile_normal_ios", in: .module, compatibleWith: nil),
            options: [
                .transition(.fade(0.2)),
                .cacheOriginalImage
            ]
        )
    }
}
