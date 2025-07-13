//
//  LaunchScreen.swift
//  HilingualPresentation
//
//  Created by 성현주 on 7/11/25.
//

import UIKit

public final class LaunchScreen: UIViewController {

    // MARK: - UI Properties

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "img_logo_ios", in: .module, compatibleWith: nil)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: - Life Cycle
    public override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setLayout()
    }

}

// MARK: - Extensions

extension LaunchScreen {
    private func setUI() {
        view.backgroundColor = .hilingualOrange
        view.addSubview(logoImageView)
    }

    private func setLayout() {
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(180)
            $0.centerX.equalToSuperview()
        }
    }
}
