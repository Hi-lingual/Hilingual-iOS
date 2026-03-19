//
//  CustomTabBarView.swift
//  HilingualPresentation
//
//  Created by 성현주 on 3/1/26.
//

import UIKit
import SnapKit
@preconcurrency import GoogleMobileAds

struct CustomTabBarItem {
    let title: String
    let selectedImageName: String
    let unselectedImageName: String
}

final class CustomTabBarView: UIView {

    private enum Layout {
        static let tabHeight: CGFloat = 58
        static let adHeight: CGFloat = 24
    }

    private enum Ads {
        static let nativeTestUnitID = "ca-app-pub-3940256099942544/3986624511"
        static let fallbackTitle = "광고 이름"
    }

    // MARK: - Callback

    var onSelect: ((Int) -> Void)?
    var onAdVisibilityChanged: ((Bool) -> Void)?

    // MARK: - UI

    private let topDivider: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()

    private let adContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private let adBadgeLabel: UILabel = {
        let label = UILabel()
        label.text = "AD"
        label.font = .pretendard(.cap_r_12)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = .gray500
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        return label
    }()

    private let adTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.cap_r_12)
        label.textColor = .gray700
        label.numberOfLines = 1
        label.text = Ads.fallbackTitle
        return label
    }()

    private var adHeightConstraint: Constraint?
    private var adLoader: AdLoader?
    private var nativeAd: NativeAd?
    private var isAdVisible = false
    private lazy var adLoaderDelegate = CustomNativeAdLoaderDelegate(owner: self)
    
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

    func loadAd() {
        loadTestNativeAd()
    }

    // MARK: - Private

    private func setupUI() {
        backgroundColor = .white
        addSubviews(topDivider, stackView, adContainerView)
        adContainerView.addSubviews(adBadgeLabel, adTitleLabel)
        adContainerView.isHidden = true
        itemViews.forEach { stackView.addArrangedSubview($0) }
    }

    private func setupLayout() {
        topDivider.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }

        stackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(Layout.tabHeight)
        }

        adContainerView.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            adHeightConstraint = $0.height.equalTo(0).constraint
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }

        adBadgeLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(24)
            $0.height.equalTo(16)
        }

        adTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(adBadgeLabel.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
        }
    }

    private func bindActions() {
        itemViews.forEach { itemView in
            itemView.onTap = { [weak self] index in
                self?.onSelect?(index)
            }
        }
    }

    private func setAdVisible(_ visible: Bool) {
        guard isAdVisible != visible else { return }
        isAdVisible = visible
        adContainerView.isHidden = !visible
        adHeightConstraint?.update(offset: visible ? Layout.adHeight : 0)
        onAdVisibilityChanged?(visible)
    }

    private func loadTestNativeAd() {
        let adLoader = AdLoader(
            adUnitID: Ads.nativeTestUnitID,
            rootViewController: nil,
            adTypes: [.native],
            options: nil
        )
        adLoader.delegate = adLoaderDelegate
        self.adLoader = adLoader
        adLoader.load(Request())
    }

    fileprivate func handleAdLoadSuccess(_ nativeAd: NativeAd) {
        self.nativeAd = nativeAd
        adTitleLabel.text = nativeAd.headline ?? Ads.fallbackTitle
        setAdVisible(true)
    }

    fileprivate func handleAdLoadFailure() {
        setAdVisible(false)
    }
}

// MARK: - NativeAdLoaderDelegate

private final class CustomNativeAdLoaderDelegate: NSObject, NativeAdLoaderDelegate {
    
    weak var owner: CustomTabBarView?

    init(owner: CustomTabBarView) {
        self.owner = owner
    }

    func adLoader(_ adLoader: AdLoader, didReceive nativeAd: NativeAd) {
        let owner = self.owner
        DispatchQueue.main.async {
            owner?.handleAdLoadSuccess(nativeAd)
        }
    }

    func adLoader(_ adLoader: AdLoader, didFailToReceiveAdWithError error: Error) {
        let owner = self.owner
        DispatchQueue.main.async {
            owner?.handleAdLoadFailure()
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
