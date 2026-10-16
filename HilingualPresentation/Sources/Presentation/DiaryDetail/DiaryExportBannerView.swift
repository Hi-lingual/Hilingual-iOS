//
//  DiaryExportBannerView.swift
//  HilingualPresentation
//
//  Created by 진소은 on 10/14/26.
//

import UIKit
import SnapKit

final class DiaryExportBannerView: BaseUIView {

    // MARK: - Properties

    var onTap: (() -> Void)?

    // MARK: - UI Components

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "일기 카드로 내보내기"
        label.font = .pretendard(.body_m_14)
        label.textColor = .hilingualOrange
        return label
    }()

    private let downloadImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ic_download_20_ios", in: .module, with: nil))
        imageView.tintColor = .hilingualOrange
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: - setUI

    override func setUI() {
        backgroundColor = .hilingualOrange50
        layer.cornerRadius = 8
        layer.masksToBounds = true

        addSubviews(titleLabel, downloadImageView)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
    }

    override func setLayout() {
        snp.makeConstraints {
            $0.height.equalTo(40)
        }

        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
        }

        downloadImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(20)
        }
    }

    // MARK: - Actions

    @objc private func handleTap() {
        onTap?()
    }
}
