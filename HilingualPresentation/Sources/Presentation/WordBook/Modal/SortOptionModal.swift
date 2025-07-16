//
//  SortOptionModal.swift
//  HilingualPresentation
//
//  Created by 성현주 on 7/16/25.
//

import UIKit
import SnapKit

// MARK: - SortOptionModal

final class SortOptionModal: UIView {

    // MARK: - UI Components

    private let modalSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()

    private let modalLabel: UILabel = {
        let label = UILabel()
        label.text = "단어 정렬"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()

    // MARK: - State

    private var selectedIndex: Int?

    // MARK: - LifeCycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setStyle() {
        backgroundColor = UIColor.black.withAlphaComponent(0.3)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissModal))
        self.addGestureRecognizer(tap)
    }

    private func setUI() {
        addSubview(modalSheetView)
        modalSheetView.addSubviews(modalLabel, stackView)
    }

    private func setLayout() {
        modalSheetView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }

        modalLabel.snp.makeConstraints {
            $0.top.equalTo(modalSheetView).inset(24)
            $0.horizontalEdges.equalTo(modalSheetView).inset(16)
        }

        stackView.snp.makeConstraints {
            $0.top.equalTo(modalLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalTo(modalSheetView).inset(16)
            $0.bottom.equalTo(modalSheetView).inset(62)
        }
    }

    // MARK: - Public

    public func configure(title: String, items: [(String, UIImage?, () -> Void)], selectedIndex: Int?) {
        modalLabel.text = title
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        self.selectedIndex = selectedIndex

        for (index, (title, image, action)) in items.enumerated() {
            let isSelected = index == selectedIndex
            let itemView = SortOptionItemView(title: title, icon: image, isSelected: isSelected) { [weak self] in
                self?.selectedIndex = index
                action()
                self?.configure(title: title, items: items, selectedIndex: index)
            }
            stackView.addArrangedSubview(itemView)
        }
    }

    // MARK: - Animation

    public func showAnimation() {
        modalSheetView.transform = CGAffineTransform(translationX: 0, y: modalSheetView.frame.height)
        self.backgroundColor = .clear
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut]) {
            self.modalSheetView.transform = .identity
            self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        }
    }

    @objc private func dismissModal() {
        UIView.animate(withDuration: 0.2, animations: {
            self.modalSheetView.transform = CGAffineTransform(translationX: 0, y: self.modalSheetView.frame.height)
            self.backgroundColor = UIColor.clear
        }, completion: { _ in
            self.isHidden = true
        })
    }
}
