//
//  SegmentToggle.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 6/18/26.
//

import UIKit
import SnapKit

final class SegmentToggle: UIControl {

    // MARK: - Properties

    private let titles: [String]
    private(set) var selectedIndex: Int = 0

    var onIndexChanged: ((Int) -> Void)?

    // MARK: - UI Components

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray200
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()

    private let thumbView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 13
        return view
    }()

    private var segmentButtons: [UIButton] = []

    // MARK: - Init

    init(titles: [String]) {
        self.titles = titles
        super.init(frame: .zero)
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods

    private func setUI() {
        addSubview(containerView)
        containerView.addSubview(thumbView)

        titles.enumerated().forEach { index, title in
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = .pretendard(.body_m_14)
            button.tag = index
            button.addTarget(self, action: #selector(segmentTapped(_:)), for: .touchUpInside)
            containerView.addSubview(button)
            segmentButtons.append(button)
        }

        updateAppearance(animated: false)
    }

    private func setLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(31)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutSegments()
    }

    private func layoutSegments() {
        guard !segmentButtons.isEmpty else { return }

        let padding: CGFloat = 3
        let totalWidth = containerView.bounds.width
        let segmentWidth = (totalWidth - padding * 2) / CGFloat(titles.count)
        let thumbWidth = segmentWidth
        let thumbHeight = containerView.bounds.height - padding * 2

        thumbView.frame = CGRect(
            x: padding + CGFloat(selectedIndex) * segmentWidth,
            y: padding,
            width: thumbWidth,
            height: thumbHeight
        )

        segmentButtons.enumerated().forEach { index, button in
            button.frame = CGRect(
                x: padding + CGFloat(index) * segmentWidth,
                y: padding,
                width: segmentWidth,
                height: thumbHeight
            )
        }
    }

    // MARK: - Action

    @objc private func segmentTapped(_ sender: UIButton) {
        select(index: sender.tag, animated: true)
        onIndexChanged?(sender.tag)
        sendActions(for: .valueChanged)
    }

    func select(index: Int, animated: Bool) {
        guard index != selectedIndex, index < titles.count else { return }
        selectedIndex = index
        updateAppearance(animated: animated)
    }

    private func updateAppearance(animated: Bool) {
        let action = {
            self.layoutSegments()
            self.segmentButtons.enumerated().forEach { index, button in
                let isSelected = index == self.selectedIndex
                button.setTitleColor(
                    isSelected ? .hilingualOrange : .gray500,
                    for: .normal
                )
                button.titleLabel?.font = .pretendard(isSelected ? .body_m_14 : .body_r_14)
            }
        }

        if animated {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: action)
        } else {
            action()
        }
    }
}
