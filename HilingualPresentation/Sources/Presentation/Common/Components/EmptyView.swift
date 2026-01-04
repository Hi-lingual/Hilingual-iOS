//
//  EmptyView.swift
//  HilingualPresentation
//
//  Created by 조영서 on 8/15/25.
//

import UIKit
import SnapKit

final class EmptyView: UIView {
    
    // MARK: - UI Components
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.head_r_18)
        label.textColor = .gray500
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
        setDefault()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setUI() {
        addSubview(stackView)
        stackView.addArrangedSubviews(
            imageView,
            messageLabel
        )
    }
    
    private func setLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.width.equalTo(200)
            $0.height.equalTo(100)
        }
    }
    
    private func setDefault() {
        configure(
            message: "피드에 아직 공유된 일기가 없어요.",
            imageName: "img_diary_empty_ios"
        )
    }
    
    // MARK: - Configure
    
    func configure(
        message: String,
        imageName: String? = nil
    ) {
        messageLabel.text = message
        
        if let imageName {
            imageView.image = UIImage(
                named: imageName,
                in: .module,
                compatibleWith: nil
            )
        }
    }
}
