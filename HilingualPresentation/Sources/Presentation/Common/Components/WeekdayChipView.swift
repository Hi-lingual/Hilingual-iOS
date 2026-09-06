//
//  WeekdayChipView.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 9/6/26.
//

import UIKit
import SnapKit

final class WeekdayChipView: UIView {

    // MARK: - Properties

    let weekday: Int
    private(set) var isSelected: Bool = false {
        didSet { configure() }
    }

    var onTap: ((Int) -> Void)?

    // MARK: - UI Components

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body_m_16)
        label.textAlignment = .center
        return label
    }()

    // MARK: - Life Cycle

    init(weekday: Int, title: String) {
        self.weekday = weekday
        super.init(frame: .zero)
        titleLabel.text = title
        setUI()
        setLayout()
        setAction()
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setting Methods

    private func setUI() {
        addSubview(titleLabel)
        layer.cornerRadius = 20
        clipsToBounds = true
    }

    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        snp.makeConstraints {
            $0.width.height.equalTo(40)
        }
    }

    private func setAction() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(chipTapped))
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }

    @objc private func chipTapped() {
        onTap?(weekday)
    }

    // MARK: - Public

    func setSelected(_ selected: Bool) {
        isSelected = selected
    }

    func setInteractive(_ isInteractive: Bool) {
        isUserInteractionEnabled = isInteractive
    }

    private func configure() {
        backgroundColor = isSelected ? .hilingualOrange : .gray200
        titleLabel.textColor = isSelected ? .white : .gray500
    }
}
