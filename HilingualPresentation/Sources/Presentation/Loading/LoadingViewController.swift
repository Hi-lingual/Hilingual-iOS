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
    
    private let loadingView = LoadingView()
    private var interstitial: InterstitialAd?
    
    private let retryTappedSubject = PassthroughSubject<Void, Never>()
    private let closeTappedSubject = PassthroughSubject<Void, Never>()
    
    private var currentDiaryId: Int?
    
    // MARK: - Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        addTarget()
        setStyle()
        loadInterstitialAd()
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
    
    private func loadInterstitialAd() {
        InterstitialAd.load(
            with: Bundle.main.infoDictionary?["AD_INTERSTITIAL_UNIT_ID"] as? String ?? "",
            request: Request()
        ) { [weak self] ad, error in
            if let error {
                print("Interstitial load failed: \(error)")
                return
            }
            self?.interstitial = ad
            self?.interstitial?.fullScreenContentDelegate = self
        }
    }
    
    private func goToNextView() {
        viewModel?.diaryIdPublisher
            .compactMap { $0 }
            .first()
            .sink { [weak self] (diaryId: Int) in
                guard let self = self else { return }
                self.currentDiaryId = diaryId
                if let ad = self.interstitial {
                    ad.present(from: self)
                } else {
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
        guard let diaryId = currentDiaryId else { return }
        viewModel?.patchAdWatch(diaryId: diaryId)
        pushDiaryDetail(diaryId: diaryId)
    }
    
    public func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Interstitial present failed: \(error)")
        guard let diaryId = currentDiaryId else { return }
        pushDiaryDetail(diaryId: diaryId)
    }
}
