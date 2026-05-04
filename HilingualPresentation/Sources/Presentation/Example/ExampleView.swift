//
//  HomeView.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import UIKit
import SnapKit

final class ExampleView: BaseUIView {

    //MARK: - UI Components

    let rateLabel: UILabel = {
        let label = UILabel()
        label.text = "환율을 조회해보세요"
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        return label
    }()

    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Image", in: .module, compatibleWith: nil)
        return imageView
    }()

    let fetchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("환율 조회", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        return button
    }()

    //MARK: - Custom Method

    override func setUI() {
        addSubviews(rateLabel,fetchButton,iconImageView)
    }

    override func setLayout() {
        rateLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        fetchButton.snp.makeConstraints {
            $0.top.equalTo(rateLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(120)
            $0.height.equalTo(44)
        }

        iconImageView.snp.makeConstraints {
            $0.top.equalTo(fetchButton.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(100)
        }
    }
}
