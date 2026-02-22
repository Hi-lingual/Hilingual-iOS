//
//  OnBoardingIndicatorView.swift
//  HilingualPresentation
//
//  Created by 성현주 on 2/12/26.
//

import Foundation
import UIKit
import SnapKit

final class OnBoardingIndicatorView: UIView {

    private var indicators: [UIView] = []
    private var widthConstraints: [Constraint] = []

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(count: Int) {
        indicators.forEach { $0.removeFromSuperview() }
        indicators.removeAll()
        widthConstraints.removeAll()

        for _ in 0..<count {
            let indicator = UIView()
            indicator.backgroundColor = .gray200
            indicator.layer.cornerRadius = 4

            stackView.addArrangedSubview(indicator)
            indicator.snp.makeConstraints {
                widthConstraints.append($0.width.equalTo(8).constraint)
                $0.height.equalTo(8)
            }
            indicators.append(indicator)
        }
    }

    func update(currentIndex: Int, animated: Bool = true) {
        let updates = { [weak self] in
            guard let self else { return }
            for (index, indicator) in self.indicators.enumerated() {
                let selected = index == currentIndex
                indicator.backgroundColor = selected ? .hilingualOrange : .gray200
                self.widthConstraints[index].update(offset: selected ? 20 : 8)
            }
            self.layoutIfNeeded()
        }

        if animated {
            UIView.animate(withDuration: 0.2, animations: updates)
        } else {
            updates()
        }
    }
}
