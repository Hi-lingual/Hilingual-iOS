//
//  CustomCalendarCell.swift
//  HilingualPresentation
//
//  Created by 조영서 on 8/2/25.
//

import UIKit
import SnapKit

final class CustomCalendarCell: UICollectionViewCell {

    // MARK: - UI Components

    private let bubbleView = UIImageView()
    private let dayLabel = UILabel()
    private let dotView = UIView()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods

    private func setupUI() {
        contentView.addSubview(bubbleView)
        contentView.addSubview(dayLabel)
        contentView.addSubview(dotView)

        dayLabel.font = .pretendard(.body_m_14)
        dayLabel.textColor = .black

        dotView.backgroundColor = .hilingualBlue
        dotView.layer.cornerRadius = 2
        dotView.isHidden = true
    }

    private func setupLayout() {
        bubbleView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(34)
        }

        dayLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        dotView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(bubbleView.snp.bottom).offset(4)
            $0.size.equalTo(CGSize(width: 4, height: 4))
        }
    }

    // MARK: - Private Methods

    private func animateAppearance() {
        bubbleView.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)

        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            usingSpringWithDamping: 0.45,
            initialSpringVelocity: 1.5,
            options: [.curveEaseOut],
            animations: {
                self.bubbleView.transform = .identity
            }
        )
    }

    // MARK: - Configure

    func configure(
        day: Int,
        isToday: Bool,
        isSelected: Bool,
        isFilled: Bool,
        isWithinMonth: Bool
    ) {
        dayLabel.text = "\(day)"
        dayLabel.textColor = isWithinMonth ? .black : .gray200

        bubbleView.image = nil

        if isSelected {
            bubbleView.image = UIImage(
                named: "img_bubble_filled_ios",
                in: .module,
                compatibleWith: nil
            )
            dayLabel.textColor = .white
            animateAppearance()
        } else if isFilled {
            bubbleView.image = UIImage(
                named: "img_bubble_written_ios",
                in: .module,
                compatibleWith: nil
            )
            dayLabel.textColor = .hilingualBlue
        }

        dotView.isHidden = !isToday
    }
}
