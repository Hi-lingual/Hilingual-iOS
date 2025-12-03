//
//  UnderlineSegmentedControl.swift
//  HilingualPresentation
//
//  Created by 진소은 on 7/11/25.
//


import UIKit
import SnapKit

final class UnderlineSegmentedControl: UIView {
    
    // MARK: - Properties
    private var buttons: [UIButton] = []
    private let stackView = UIStackView()
    private let underlineView = UIView()
    
    var selectedIndex: Int = 0 {
        didSet {
            updateUI(animated: true)
            didSelectIndex?(selectedIndex)
        }
    }
    
    var didSelectIndex: ((Int) -> Void)?
    
    // MARK: - Init
    init(items: [String]) {
        super.init(frame: .zero)
        setupUI(items: items)
        selectedIndex = 0
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupUI(items: [String]) {
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.snp.makeConstraints { $0.edges.equalToSuperview() }

        for (index, title) in items.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.setTitleColor(.lightGray, for: .normal)
            button.titleLabel?.font = UIFont.pretendard(.head_sb_18)
            button.tag = index
            button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
            buttons.append(button)
        }

        underlineView.backgroundColor = .black
        underlineView.layer.cornerRadius = 1
        stackView.addSubview(underlineView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        DispatchQueue.main.async { [weak self] in
            self?.updateUI(animated: false)
        }
    }

    // MARK: - Actions
    @objc private func didTapButton(_ sender: UIButton) {
        selectedIndex = sender.tag
    }

    private func updateUI(animated: Bool) {
        for (index, button) in buttons.enumerated() {
            let isSelected = index == selectedIndex
            button.setTitleColor(isSelected ? .black : .gray500, for: .normal)
            button.titleLabel?.font = isSelected
                ? UIFont.pretendard(.head_sb_18)
                : UIFont.pretendard(.head_m_18)
        }

        let selectedButton = buttons[selectedIndex]
        let underlineHeight: CGFloat = 3
        let underlineInset: CGFloat = 16

        let targetFrame = CGRect(
            x: selectedButton.frame.origin.x + underlineInset,
            y: bounds.height - underlineHeight,
            width: selectedButton.frame.width - (underlineInset * 2),
            height: underlineHeight
        )

        if animated {
            UIView.animate(withDuration: 0.25 ) {
                self.underlineView.frame = targetFrame
            }
        } else {
            underlineView.frame = targetFrame
        }
    }

}
