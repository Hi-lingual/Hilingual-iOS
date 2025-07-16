//
//  File.swift
//  HilingualPresentation
//
//  Created by 성현주 on 7/16/25.
//

import Foundation
import UIKit

final class SortOptionItemView: UIView {

    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let checkmarkImageView = UIImageView()
    private var tapAction: (() -> Void)?

    init(title: String, icon: UIImage?, isSelected: Bool, action: @escaping () -> Void) {
        super.init(frame: .zero)
        tapAction = action
        setupUI(title: title, icon: icon, isSelected: isSelected)
        setupTapGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI(title: String, icon: UIImage?, isSelected: Bool) {
        iconImageView.image = icon
        iconImageView.tintColor = isSelected ? .black : .lightGray
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.snp.makeConstraints { $0.width.height.equalTo(20) }

        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = isSelected ? .black : .lightGray

        checkmarkImageView.image = UIImage(systemName: "checkmark")
        checkmarkImageView.tintColor = .black
        checkmarkImageView.isHidden = !isSelected
        checkmarkImageView.snp.makeConstraints { $0.width.height.equalTo(18) }

        let hStack = UIStackView(arrangedSubviews: [iconImageView, titleLabel, UIView(), checkmarkImageView])
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.spacing = 8

        addSubview(hStack)
        hStack.snp.makeConstraints { $0.edges.equalToSuperview().inset(12) }

        self.layer.cornerRadius = 8
    }

    private func setupTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.addGestureRecognizer(tap)
    }

    @objc private func tapped() {
        tapAction?()
    }
}
