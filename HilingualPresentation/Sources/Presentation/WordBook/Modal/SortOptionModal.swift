//
//  SortOptionModal.swift
//  HilingualPresentation
//
//  Created by 성현주 on 7/16/25.
//

import UIKit
import SnapKit

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
    private var onSelect: ((Int) -> Void)?

    private let sortOptions: [(title: String, selectedIconName: String, unselectedIconName: String)] = [
        ("최신순", "ic_listdown_black_24_ios", "ic_listdown_gray_24_ios"),
        ("A-Z순", "ic_az_black_24_ios", "ic_az_gray_24_ios")
    ]

    // MARK: - Init

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

    public func configure(selectedIndex: Int, onSelect: @escaping (Int) -> Void) {
        self.selectedIndex = selectedIndex
        self.onSelect = onSelect
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for (index, option) in sortOptions.enumerated() {
            let isSelected = index == selectedIndex
            let iconName = isSelected ? option.selectedIconName : option.unselectedIconName
            let icon = UIImage(named: iconName, in: .module, compatibleWith: nil)

            let itemView = SortOptionItemView(
                title: option.title,
                icon: icon,
                isSelected: isSelected
            ) { [weak self] in
                self?.selectedIndex = index
                self?.onSelect?(index)
                self?.dismissModal()
            }

            stackView.addArrangedSubview(itemView)
        }
    }

    // MARK: - Animation

    public func showAnimation() {
        modalSheetView.transform = CGAffineTransform(translationX: 0, y: modalSheetView.frame.height)
        self.backgroundColor = .clear
        UIView.animate(withDuration: 0.3) {
            self.modalSheetView.transform = .identity
            self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        }
    }

    public func dismiss(completion: (() -> Void)? = nil) {
        layoutIfNeeded()
        let sheetHeight = modalSheetView.bounds.height

        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       options: [.curveEaseIn],
                       animations: {
            self.modalSheetView.transform = CGAffineTransform(translationX: 0, y: sheetHeight)
            self.backgroundColor = .clear
        }, completion: { _ in
            self.isHidden = true
            completion?()
        })
    }

    @objc private func dismissModal() {
        UIView.animate(withDuration: 0.2, animations: {
            self.modalSheetView.transform = CGAffineTransform(translationX: 0, y: self.modalSheetView.frame.height)
            self.backgroundColor = .clear
        }, completion: { _ in
            self.isHidden = true
        })
    }
}
