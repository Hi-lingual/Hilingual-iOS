//
//  CustomTabBarView.swift
//  HilingualPresentation
//
//  Created by 성현주 on 3/1/26.
//

import UIKit
import SnapKit

struct CustomTabBarItem {
    let title: String
    let selectedImageName: String
    let unselectedImageName: String
}

final class CustomTabBarView: UIView {

    // MARK: - Callback

    var onSelect: ((Int) -> Void)?

    // MARK: - UI

    private let topDivider: UIView = {
        let view = UIView()
        view.backgroundColor = .gray200
        return view
    }()

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()

    private let itemViews: [CustomTabBarItemView]

    // MARK: - Init

    init(items: [CustomTabBarItem]) {
        self.itemViews = items.enumerated().map { index, item in
            CustomTabBarItemView(index: index, item: item)
        }
        super.init(frame: .zero)
        setupUI()
        setupLayout()
        bindActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public

    func setSelectedIndex(_ index: Int) {
        itemViews.forEach { $0.isItemSelected = ($0.itemIndex == index) }
    }

    // MARK: - Private

    private func setupUI() {
        backgroundColor = .white
        addSubviews(topDivider, stackView)
        itemViews.forEach { stackView.addArrangedSubview($0) }
    }

    private func setupLayout() {
        topDivider.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }

        stackView.snp.makeConstraints {
            $0.top.equalTo(topDivider.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
    }

    private func bindActions() {
        itemViews.forEach { itemView in
            itemView.onTap = { [weak self] index in
                self?.onSelect?(index)
            }
        }
    }
}

// MARK: - CustomTabBarItemView

private final class CustomTabBarItemView: UIControl {

    // MARK: - Properties

    let itemIndex: Int
    private let item: CustomTabBarItem
    var onTap: ((Int) -> Void)?

    var isItemSelected: Bool = false {
        didSet { updateAppearance() }
    }

    // MARK: - UI

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.cap_r_12)
        label.textAlignment = .center
        return label
    }()

    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 2
        stack.isUserInteractionEnabled = false
        return stack
    }()

    // MARK: - Init

    init(index: Int, item: CustomTabBarItem) {
        self.itemIndex = index
        self.item = item
        super.init(frame: .zero)
        setupUI()
        setupLayout()
        addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    private func setupUI() {
        titleLabel.text = item.title
        addSubview(contentStack)
        contentStack.addArrangedSubviews(iconImageView, titleLabel)
        updateAppearance()
    }

    private func setupLayout() {
        contentStack.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        iconImageView.snp.makeConstraints {
            $0.size.equalTo(24)
        }
    }

    private func updateAppearance() {
        let imageName = isItemSelected ? item.selectedImageName : item.unselectedImageName
        iconImageView.image = UIImage(named: imageName, in: .module, compatibleWith: nil)?
            .withRenderingMode(.alwaysOriginal)
        titleLabel.textColor = isItemSelected ? .black : .gray400
    }

    @objc
    private func didTap() {
        onTap?(itemIndex)
    }
}
