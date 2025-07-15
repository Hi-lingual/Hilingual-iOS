//
//  SplashView.swift
//  HilingualPresentation
//
//  Created by 성현주 on 7/15/25.
//

import UIKit
import SnapKit

final class SplashView: BaseUIView {

    // MARK: - UI Components

    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "img_logo_ios", in: .module, compatibleWith: nil)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: - Setup

    override func setUI() {
        backgroundColor = .hilingualOrange
        addSubview(logoImageView)
    }

    override func setLayout() {
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(180)
            $0.centerX.equalToSuperview()
        }
    }
}
