//
//  CardPreview.swift
//  HilingualPresentation
//
//  Created by 조영서 on 7/10/25.
//

import UIKit
import SnapKit
import Kingfisher

final class CardPreview: UIView {

    // MARK: - UI Components

    private let previewLine: UIView = {
        let view = UIView()
        view.backgroundColor = .hilingualBlack
        return view
    }()

    private let originalText: UILabel = {
        let label = UILabel()
        label.font = .suit(.body_m_16)
        label.textColor = .black
        label.numberOfLines = 3
        return label
    }()

    private let previewImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(
            named: "img_profile_normal_ios",
            in: .module,
            compatibleWith: nil
        )
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()

    private let cardStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods

    private func setupUI() {
        backgroundColor = .white

        cardStack.addArrangedSubviews(
            previewLine,
            originalText
        )

        addSubviews(cardStack, previewImage)
    }

    private func setupLayout() {
        
        previewLine.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 3, height: 74))
        }

        cardStack.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(74)
        }
        
        originalText.snp.makeConstraints {
            $0.trailing.lessThanOrEqualTo(previewImage.snp.leading).offset(-8)
        }
        
        previewImage.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(74)
        }
    }

    // MARK: - Configuration

    enum CardPreviewType {
        case textOnly(text: String?)
        case textWithImage(text: String?, imageUrl: String?)
    }

    func configure(type: CardPreviewType) {
        switch type {
        case .textOnly(let text):
            originalText.text = text ?? "일기를 불러오지 못했습니다."
            previewImage.isHidden = true
            
            originalText.snp.remakeConstraints {
                $0.trailing.lessThanOrEqualTo(previewImage.snp.leading).offset(-16)
            }
            
            previewImage.snp.remakeConstraints {
                $0.trailing.equalToSuperview()
                $0.centerY.equalToSuperview()
                $0.size.equalTo(0)
            }

        case .textWithImage(let text, let imageUrl):
            originalText.text = text ?? "일기를 불러오지 못했습니다."

            previewImage.isHidden = false
            if let urlString = imageUrl, let url = URL(string: urlString) {
                previewImage.kf.setImage(with: url)
            } else {
                previewImage.image = UIImage(named: "img_profile_normal_ios", in: .module, compatibleWith: nil)
            }
        }
    }
}
