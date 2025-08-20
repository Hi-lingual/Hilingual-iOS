//
//  SharedProfileView.swift
//  HilingualPresentation
//
//  Created by 진소은 on 8/20/25.
//

import UIKit
import SnapKit

public class SharedProfileView: UIView {
    
    // MARK: - UI Components
    
    private let profileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 21
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.gray200.cgColor
        return imageView
    }()
    
    private let infoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    private let headerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        return stack
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .suit(.head_b_16)
        label.textColor = .gray850
        label.numberOfLines = 1
        return label
    }()
    
    private let streakStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 0
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
        label.font = .suit(.caption_r_14)
        return label
    }()
    
    private let sharedDateLabel: UILabel = {
        let label = UILabel()
        label.font = .suit(.caption_r_12)
        label.textColor = .gray500
        return label
    }()
    
    private let likeView = LikeCounterView(style: .vertical)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetUI
    
    private func setUI() {
        self.backgroundColor = .white
        
        self.addSubviews(profileImageView, infoStackView, likeView)
        infoStackView.addArrangedSubviews(headerStackView, sharedDateLabel)
        headerStackView.addArrangedSubviews(nameLabel, streakStackView)
        streakStackView.addArrangedSubviews(streakImageView, streakLabel)
    }
    
    private func setLayout() {
        
        self.snp.makeConstraints {
            $0.height.equalTo(62)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide.snp.horizontalEdges)
        }
        
        profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(42)
        }
        
        infoStackView.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
        }
        
        headerStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
        }
        
        sharedDateLabel.snp.makeConstraints {
            $0.height.equalTo(15)
        }
        
        likeView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(24)
        }
    }
}
