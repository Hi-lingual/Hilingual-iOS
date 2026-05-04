//
//  LoginOnBoardingPageCell.swift
//  HilingualPresentation
//
//  Created by 성현주 on 2/12/26.
//

import UIKit
import SnapKit

final class LoginOnBoardingPageCell: UICollectionViewCell {

    static let cellIdentifier = "LoginOnBoardingPageCell"

    private let previewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(previewImageView)
        previewImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(imageName: String) {
        previewImageView.image = UIImage(named: imageName, in: .module, compatibleWith: nil)
    }
}
