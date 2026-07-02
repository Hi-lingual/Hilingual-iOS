//
//  LoadingViewController.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 7/11/25.
//

import Foundation
import Combine
import GoogleMobileAds

public final class LoadingViewController: BaseUIViewController<LoadingViewModel> {
    
    // MARK: - Properties
    
    private var adLoadRetryCount = 0
    private static let maxAdRetryCount = 3
    private var pendingDiaryId: Int?
    
    private let loadingView = LoadingView()
    private var interstitial: InterstitialAd?
    
    private var adLoadTimestamp: Date?
    
    private let retryTappedSubject = PassthroughSubject<Void, Never>()
    private let closeTappedSubject = PassthroughSubject<Void, Never>()
    
    private var currentDiaryId: Int?
    
    // MARK: - Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        addTarget()
        setStyle()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Setup
    
    public func setStyle() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    public override func setUI() {
        view.addSubviews(loadingView)
        
        loadingView.onCloseTapped = { [weak self] in
            self?.closeTappedSubject.send(())
        }
    }
    
    public override func setLayout() {
        loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    public override func addTarget() {
        loadingView.feedbackButton.addTarget(self, action: #selector(feedbackButtonTapped), for: .touchUpInside)
        loadingView.closeIcon.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Action
    
    @objc private func feedbackButtonTapped() {
        switch loadingView.currentState {
        case .loading:
            break
        case .success:
            goToNextView()
        case .error:
            retryButtonTapped()
        }
    }
    
    @objc private func retryButtonTapped() {
        retryTappedSubject.send()
    }
    
    @objc private func closeButtonTapped() {
        closeTappedSubject.send()
    }
    
    // MARK: - Bind
    
    public override func bind(viewModel: LoadingViewModel) {
        super.bind(viewModel: viewModel)
        
        let input = LoadingViewModel.Input(
            startLoading: Just(()).eraseToAnyPublisher(),
            retryTapped: retryTappedSubject.eraseToAnyPublisher(),
            closeTapped: closeTappedSubject.eraseToAnyPublisher()
        )
        
        let output = viewModel.transform(input: input)
        
        output.state
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                let viewState: LoadingView.State
                switch state {
                case .loading: viewState = .loading
                case .success: viewState = .success
                case .error: viewState = .error
                }
                self.loadingView.configure(for: viewState)
            }
            .store(in: &cancellables)
        
        output.goToHome
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.goToHomeView() }
            .store(in: &cancellables)
    }
    
    // MARK: - Navigation
    
    public func preloadAd() {
        if let _ = interstitial, isAdValid() { return }
        
        let unitID = Bundle.main.infoDictionary?["AD_INTERSTITIAL_UNIT_ID"] as? String ?? ""
        
        InterstitialAd.load(with: unitID, request: Request()) { [weak self] ad, error in
            guard let self = self else { return }
            
            if let error = error {
                print("❌ 광고 로드 실패: \(error.localizedDescription)")
                self.retryLoadingAdIfNeeded()
                return
            }
            
            guard let ad = ad else {
                print("🚨 예외 상황: 에러는 없으나 광고 객체가 nil입니다.")
                self.retryLoadingAdIfNeeded()
                return
            }
            
            self.adLoadRetryCount = 0
            self.interstitial = ad
            self.interstitial?.fullScreenContentDelegate = self
            self.adLoadTimestamp = Date()
            print("✅ 광고 로드 완료")
            
            if let pendingDiaryId = self.pendingDiaryId {
                self.pendingDiaryId = nil
                self.currentDiaryId = pendingDiaryId
                
                DispatchQueue.main.async {
                    ad.present(from: self)
                }
            }
        }
    }
    
    private func isAdValid() -> Bool {
        guard let timestamp = adLoadTimestamp else { return false }
        return Date().timeIntervalSince(timestamp) < 3600
    }
    
    private func retryLoadingAdIfNeeded() {
        guard adLoadRetryCount < Self.maxAdRetryCount else {
            print("🚨 재시도 횟수 초과 (\(Self.maxAdRetryCount)회) -> 광고 없이 화면 이동")
            if let pendingDiaryId = self.pendingDiaryId {
                self.pendingDiaryId = nil
                DispatchQueue.main.async {
                    self.pushDiaryDetail(diaryId: pendingDiaryId)
                }
            }
            return
        }
        
        let delay = pow(2.0, Double(adLoadRetryCount))
        adLoadRetryCount += 1
        print("🔄 광고 재시도 예약: \(delay)초 후 로드 (시도 \(adLoadRetryCount)/\(Self.maxAdRetryCount))")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.preloadAd()
        }
    }
    
    private func goToNextView() {
        viewModel?.diaryIdPublisher
            .compactMap { $0 }
            .first()
            .sink { [weak self] (diaryId: Int) in
                guard let self = self else { return }
                
                if let ad = self.interstitial, self.isAdValid() {
                    self.currentDiaryId = diaryId
                    DispatchQueue.main.async {
                        ad.present(from: self)
                    }
                }
                else if self.adLoadRetryCount < Self.maxAdRetryCount {
                    self.pendingDiaryId = diaryId
                }
                else {
                    self.currentDiaryId = diaryId
                    self.pushDiaryDetail(diaryId: diaryId)
                }
            }
            .store(in: &cancellables)
    }
    
    private func pushDiaryDetail(diaryId: Int) {
        let detailVC = diContainer.makeDiaryDetailViewController(diaryId: diaryId)
        detailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    private func goToHomeView() {
        navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - FullScreenContentDelegate

extension LoadingViewController: FullScreenContentDelegate {
    public func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        interstitial = nil
        adLoadTimestamp = nil
        
        guard let diaryId = currentDiaryId else { return }
        viewModel?.patchAdWatch(diaryId: diaryId)
        pushDiaryDetail(diaryId: diaryId)
    }
    
    public func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        interstitial = nil
        adLoadTimestamp = nil
        
        print("🚨 전면 광고 표시 실패: \(error)")
        guard let diaryId = currentDiaryId else { return }
        pushDiaryDetail(diaryId: diaryId)
    }
}
