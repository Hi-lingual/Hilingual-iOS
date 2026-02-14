//
//  SortOptionItemView.swift
//  HilingualPresentation
//
//  Created by 성현주 on 7/16/25.
//

import UIKit
import SnapKit

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

        titleLabel.text = title
        titleLabel.font = .pretendard(.body_m_14)
        titleLabel.textColor = isSelected ? .black : .lightGray

        checkmarkImageView.image = isSelected
            ? UIImage(named: "ic_check_24_ios", in: .module, compatibleWith: nil)
            : nil
        checkmarkImageView.contentMode = .scaleAspectFit
        checkmarkImageView.isHidden = !isSelected

        let hStack = UIStackView(arrangedSubviews: [
            iconImageView,
            titleLabel,
            UIView(),
            checkmarkImageView
        ])
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.spacing = 8

        addSubview(hStack)
        hStack.snp.makeConstraints { $0.edges.equalToSuperview().inset(12) }
    }

    private func setupTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.addGestureRecognizer(tap)
    }

    @objc private func tapped() {
        tapAction?()
    }
}
