//
//  MilestoneActionButton.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 10/16/26.
//

import UIKit
import SnapKit

final class MilestoneActionButton: UIControl {

    // MARK: - UI Components

    private let circleView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        view.layer.cornerRadius = 24
        view.isUserInteractionEnabled = false
        return view
    }()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.cap_r_12)
        label.textColor = .gray500
        label.textAlignment = .center
        return label
    }()

    // MARK: - Init

    init(icon: ImageResource, title: String) {
        super.init(frame: .zero)
        iconImageView.image = UIImage(resource: icon)
        titleLabel.text = title
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods

    private func setUI() {
        addSubviews(circleView, titleLabel)
        circleView.addSubview(iconImageView)
    }

    private func setLayout() {
        circleView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview()
            $0.size.equalTo(48)
        }

        iconImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(24)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(circleView.snp.bottom).offset(4)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
}
