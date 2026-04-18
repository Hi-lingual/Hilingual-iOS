//
//  MypageViewController.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Combine
import Foundation
import SafariServices
import GoogleMobileAds

public final class MypageViewController: BaseUIViewController<MypageViewModel> {
    
    // MARK: - Properties
    
    private let mypageView = MypageView()
    private let logoutTappedSubject = PassthroughSubject<Void, Never>()
    private var lastLoadedBannerWidth: CGFloat = 0
    private var hasReceivedBannerOnce = false
    
    // MARK: - Life Cycle
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        viewModel?.fetchUserProfile()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        loadBannerAd()
    }
    
    // MARK: - Custom Method
    
    public override func setUI() {
        super.setUI()
        
        view.addSubview(mypageView)
        
        if let value = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            mypageView.versionValueLabel.text = "\(value)"
        }
    }
    
    public override func setLayout() {
        mypageView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    public override func addTarget() {
        mypageView.logoutButton.addTarget(self, action: #selector(presentLogoutDialog), for: .touchUpInside)
        mypageView.editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        mypageView.feedButton.addTarget(self, action: #selector(myFeedProfileButtonTapped), for: .touchUpInside)
        
        mypageView.onEditProfileTap = { [weak self] in
            self?.editButtonTapped()
        }
        
        mypageView.onMenuTap = { [weak self] menu in
            guard let self else { return }
            switch menu {
            case .notification:
                let vc = self.diContainer.makeNotificationSettingViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                
            case .blockedUsers:
                let vc = self.diContainer.makeBlockUserViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                
            case .support:
                guard let url = URL(string: "https://pf.kakao.com/_kNTvn/chat") else { return }
                let safariVC = SFSafariViewController(url: url)
                self.present(safariVC, animated: true)
                
            case .policy:
                guard let url = URL(string: "https://hilingual.notion.site/230829677ebf8104b52ce74c65c27607") else { return }
                let safariVC = SFSafariViewController(url: url)
                self.present(safariVC, animated: true)
            }
        }
    }
    
    public override func bind(viewModel: MypageViewModel) {
        let input = MypageViewModel.Input(
            logoutTapped: logoutTappedSubject.eraseToAnyPublisher()
        )
        
        let output = viewModel.transform(input: input)
        
        output.logoutCompleted
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let self else { return }
                let onboardingVC = self.diContainer.makeSplashViewController()
                changeRootVC(onboardingVC,animated: true)
            }
            .store(in: &cancellables)
        
        output.logoutError
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                //TODO: - error 모달 추가하기
            }
            .store(in: &cancellables)
        
        output.userProfile
            .compactMap { $0 }
            .receive(on: RunLoop.main)
            .sink { [weak self] profile in
                self?.mypageView.configure(
                    nickname: profile.nickname,
                    profileImageURL: profile.profileImg
                )
            }
            .store(in: &cancellables)
        
    }
    
    // MARK: - PrivatMethod
    
    @objc
    func presentLogoutDialog() {
        guard let window = UIApplication.shared.windows.first else { return }
        
        let dialog = Dialog()
        
        dialog.configure(
            style: .normal,
            title: "하이링구얼에서 로그아웃 하시겠어요?",
            leftButtonTitle: "아니요",
            rightButtonTitle: "로그아웃하기",
            leftAction: {
                dialog.dismiss()
            },
            rightAction: { [weak self] in
                dialog.dismiss()
                self?.logoutTappedSubject.send(())
            }
        )
        
        window.addSubview(dialog)
        dialog.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        dialog.showAnimation()
    }
    
    @objc
    func editButtonTapped() {
        let editProfileVC = self.diContainer.makeEditProfileViewController()
        editProfileVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    @objc
    func myFeedProfileButtonTapped() {
        let myFeedProfileVC = self.diContainer.makeMyFeedProfileViewController()
        myFeedProfileVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(myFeedProfileVC, animated: true)
    }
    
    private func loadBannerAd() {
        let width = floor(mypageView.bannerContainerView.bounds.width)
        guard width > 0 else { return }
        guard abs(lastLoadedBannerWidth - width) > 0.5 else { return }
        lastLoadedBannerWidth = width

        let adSize = largeAnchoredAdaptiveBanner(width: width)

        mypageView.bannerView.delegate = self
        mypageView.bannerView.adSize = adSize
        mypageView.bannerView.rootViewController = self
        mypageView.bannerView.adUnitID = Bundle.main.infoDictionary?["AD_BANNER_UNIT_ID"] as? String ?? ""
        mypageView.updateBannerHeight(adSize.size.height)

        mypageView.bannerView.load(Request())
    }
}

// MARK: - BannerViewDelegate

extension MypageViewController: BannerViewDelegate {

    public func bannerViewDidReceiveAd(_ bannerView: BannerView) {
        mypageView.bannerPlaceholderImageView.removeFromSuperview()

        hasReceivedBannerOnce = true
        bannerView.alpha = 0
        UIView.animate(withDuration: 1) {
            bannerView.alpha = 1
        }
        mypageView.updateBannerHeight(bannerView.adSize.size.height)
    }

    public func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
        print("AdMob error:", error)
        guard hasReceivedBannerOnce == false else { return }
        mypageView.updateBannerHeight(0)
    }
}
