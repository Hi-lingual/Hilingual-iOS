//
//  KnownBadgeView.swift
//  HilingualPresentation
//
//  Created by 진소은 on 8/18/26.
//

import UIKit
import SnapKit

final class KnownBadgeView: BaseUIView {

    private let checkIconImageView = UIImageView()
    private let titleLabel = UILabel()

    override func setUI() {
        checkIconImageView.image = UIImage(resource: .icCheck16Ios)
        checkIconImageView.contentMode = .scaleAspectFit

        titleLabel.text = "아는 단어"
        titleLabel.font = .pretendard(.cap_r_12)
        titleLabel.textColor = .gray400

        addSubviews(checkIconImageView, titleLabel)
    }

    override func setLayout() {
        checkIconImageView.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
            $0.width.height.equalTo(16)
        }

        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(checkIconImageView.snp.trailing).offset(2)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
}
