//
//  NoFeedView.swift
//  HilingualPresentation
//
//  Created by 조영서 on 8/15/25.
//

import UIKit
import SnapKit

final class NoFeedView: UIView {

    private let noFeedLabel: UILabel = {
        let label = UILabel()
        label.text = "피드에 아직 공유된 일기가 없어요."
        label.font = .suit(.head_m_18)
        label.textColor = .gray500
        label.textAlignment = .center
        return label
    }()

    private let noFeedView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "img_diary_empty_ios", in: .module, compatibleWith: nil)
        return imageView
    }()

    private let noFeedStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
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
        addSubview(noFeedStack)
        noFeedStack.addArrangedSubviews(
            noFeedView,
            noFeedLabel
        )
    }

    private func setupLayout() {
        noFeedStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        noFeedView.snp.makeConstraints {
            $0.width.equalTo(200)
            $0.height.equalTo(100)
        }
    }
    
    // MARK: - Configure
    func configure(message: String? = nil, imageName: String? = nil) {
        if let message = message {
            noFeedLabel.text = message
        }
        if let imageName = imageName {
            noFeedView.image = UIImage(
                named: imageName,
                in: .module,
                compatibleWith: nil
            )
        }
    }
}
