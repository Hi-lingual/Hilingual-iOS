//
//  PreparingViewController.swift
//  HilingualPresentation
//
//  Created by 성현주 on 7/18/25.
//

import UIKit
import SnapKit

final class PreparingViewController: UIViewController {

    // MARK: - UI Components

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "img_preparing_ios", in: .module, compatibleWith: nil)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "조금만 기다려주세요.\n더 멋진 모습으로 찾아올게요!"
        label.textColor = .gray500
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = .suit(.head_m_18)
        return label
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray100
        setupLayout()
    }

    // MARK: - Layout

    private func setupLayout() {
        view.addSubview(imageView)
        view.addSubview(messageLabel)

        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(154)
        }

        messageLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
    }
}
