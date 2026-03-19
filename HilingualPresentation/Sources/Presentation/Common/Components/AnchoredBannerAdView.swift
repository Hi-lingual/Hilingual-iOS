//
//  AnchoredBannerAdView.swift
//  HilingualPresentation
//
//  Created by youngseo on 3/19/26.
//

import UIKit
import SnapKit
@preconcurrency import GoogleMobileAds

final class AnchoredBannerAdView: UIView {

    // MARK: - Properties

    private enum Ads {
        // TODO: 실제 광고 id로 변경하기
        static let adManagerAdaptiveBannerTestUnitID = "/21775744923/example/adaptive-banner"
    }

    var onHeightChanged: ((CGFloat) -> Void)?

    private var bannerView: AdManagerBannerView?
    private var bannerDelegateProxy: BannerDelegateProxy?

    private var lastRequestedWidth: CGFloat = 0
    private var lastRequestedSize: CGSize = .zero
    private var lastNotifiedHeight: CGFloat = -1

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods

    func loadIfNeeded(rootViewController: UIViewController, availableWidth: CGFloat) {
        guard UIDevice.current.userInterfaceIdiom != .pad else {
            notifyHeightChanged(0)
            return
        }

        guard rootViewController.view.window != nil else { return }

        let width = floor(availableWidth)
        guard width > 0 else {
            notifyHeightChanged(0)
            return
        }

        guard let adSize = makeAnchoredAdaptiveAdSize(width: width) else {
            lastRequestedWidth = 0
            lastRequestedSize = .zero
            notifyHeightChanged(0)
            return
        }

        guard abs(lastRequestedWidth - width) > 0.5 || lastRequestedSize != adSize.size else { return }

        lastRequestedWidth = width
        lastRequestedSize = adSize.size

        let bannerView = makeOrReuseBannerView(
            adSize: adSize,
            rootViewController: rootViewController
        )

        bannerView.load(AdManagerRequest())
    }

    // MARK: - Private Methods

    private func makeAnchoredAdaptiveAdSize(width: CGFloat) -> AdSize? {
        let current = currentOrientationAnchoredAdaptiveBanner(width: width)

        if isAdSizeValid(size: current),
           current.size.width > 0,
           current.size.height >= 50 {
            return current
        }

        let portrait = largeAnchoredAdaptiveBanner(width: width)

        if isAdSizeValid(size: portrait),
           portrait.size.width > 0,
           portrait.size.height >= 50 {
            return portrait
        }

        return nil
    }

    private func makeOrReuseBannerView(
        adSize: AdSize,
        rootViewController: UIViewController
    ) -> AdManagerBannerView {

        if let bannerView {
            bannerView.rootViewController = rootViewController
            bannerView.adSize = adSize
            return bannerView
        }

        let bannerView = AdManagerBannerView(adSize: adSize)
        bannerView.adUnitID = Ads.adManagerAdaptiveBannerTestUnitID
        bannerView.rootViewController = rootViewController

        let proxy = BannerDelegateProxy(owner: self)
        bannerView.delegate = proxy
        bannerDelegateProxy = proxy

        addSubview(bannerView)
        bannerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        self.bannerView = bannerView
        return bannerView
    }

    fileprivate func notifyAdLoaded() {
        guard let bannerView else { return }

        let height = bannerView.bounds.height > 0
            ? bannerView.bounds.height
            : bannerView.adSize.size.height

        notifyHeightChanged(height)
    }

    fileprivate func notifyAdFailed() {
        lastRequestedWidth = 0
        lastRequestedSize = .zero
        notifyHeightChanged(0)
    }

    private func notifyHeightChanged(_ height: CGFloat) {
        guard abs(lastNotifiedHeight - height) > 0.5 else { return }

        lastNotifiedHeight = height

        DispatchQueue.main.async { [weak self] in
            self?.onHeightChanged?(height)
        }
    }
}

// MARK: - Extensions

private final class BannerDelegateProxy: NSObject, BannerViewDelegate {

    weak var owner: AnchoredBannerAdView?

    init(owner: AnchoredBannerAdView) {
        self.owner = owner
    }

    func bannerViewDidReceiveAd(_ bannerView: BannerView) {
        DispatchQueue.main.async { [weak owner] in
            owner?.notifyAdLoaded()
        }
    }

    func bannerView(
        _ bannerView: BannerView,
        didFailToReceiveAdWithError error: Error
    ) {
        DispatchQueue.main.async { [weak owner] in
            owner?.notifyAdFailed()
        }
    }
}
