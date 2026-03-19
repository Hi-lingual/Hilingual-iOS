//
//  RecommendedExpressionViewController.swift
//  HilingualPresentation
//
//  Created by 진소은 on 7/10/25.
//

import Foundation
import UIKit
import Combine
import GoogleMobileAds

public final class RecommendedExpressionViewController: BaseUIViewController<RecommendedExpressionViewModel>, ScrollControllable {

    // MARK: - Properties

    private let recommendedExpressionView = RecommendedExpressionView()
    private let dialog = Dialog()
    private var pendingDate: String?

    var onBookmarkToggle: ((Int64, Bool) -> Void)?

    // MARK: - Ad

    public var showsAdBanner: Bool = false
    private var bannerView: BannerView?

    private lazy var adPlaceholderImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .imgLoadingFeedIos))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    // MARK: - LifeCycle

    public override func viewDidLoad() {
        super.viewDidLoad()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if showsAdBanner {
            adPlaceholderImageView.alpha = 1
            adPlaceholderImageView.isHidden = false
            recommendedExpressionView.setAdBannerView(adPlaceholderImageView)
            adPlaceholderImageView.snp.makeConstraints {
                $0.height.equalTo(160)
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.loadAd()
            }
        }
    }

    // MARK: - Custom Method

    public override func setUI() {
        view.addSubviews(recommendedExpressionView, dialog)
        view.backgroundColor = .gray100
        view.bringSubviewToFront(dialog)

        if showsAdBanner {
            let banner = BannerView()
            banner.adUnitID = "ca-app-pub-3940256099942544/2435281174"
            banner.rootViewController = self
            banner.delegate = self
            self.bannerView = banner

            recommendedExpressionView.setAdBannerView(adPlaceholderImageView)
        }

        if let date = pendingDate {
            recommendedExpressionView.setDate(date)
        }
    }

    public override func setLayout() {
        recommendedExpressionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        dialog.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        if showsAdBanner {
            adPlaceholderImageView.snp.makeConstraints {
                $0.height.equalTo(160)
            }
        }
    }

    private func loadAd() {
        guard let bannerView else { return }

        bannerView.adSize = inlineAdaptiveBanner(width: view.frame.width, maxHeight: 300)

        let request = Request()
        bannerView.load(request)
    }

    // MARK: - Binding

    private let bookmarkToggleSubject = PassthroughSubject<(Int, Bool), Never>()

    public override func bind(viewModel: RecommendedExpressionViewModel) {
        recommendedExpressionView.onBookmarkToggle = { [weak self] phraseId, isBookmarked in
            self?.bookmarkToggleSubject.send((Int(phraseId), isBookmarked))
            self?.onBookmarkToggle?(phraseId, isBookmarked)
        }

        let input = RecommendedExpressionViewModel.Input(
            viewDidLoad: Just(()).eraseToAnyPublisher(),
            bookmarkToggled: bookmarkToggleSubject.eraseToAnyPublisher()
        )

        let output = viewModel.transform(input: input)

        output.fetchExpression
            .map { phraseList in
                phraseList.map {
                    PhraseViewData(
                        phraseId: Int64($0.phraseId),
                        phraseType: $0.phraseType,
                        phrase: $0.phrase,
                        explanation: $0.explanation,
                        reason: $0.reason,
                        isMarked: $0.isBookmarked,
                        createdAt: ""
                    )
                }
            }
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case let .failure(error) = completion {
                        self?.showErrorDialog(message: error.localizedDescription)
                    }
                },
                receiveValue: { [weak self] viewDataList in
                    self?.recommendedExpressionView.configure(dataList: viewDataList)
                }
            )
            .store(in: &cancellables)

        output.errorMessage
            .receive(on: RunLoop.main)
            .sink { [weak self] message in
                guard let self else { return }
                let toast = ToastMessage()
                self.view.addSubview(toast)
                toast.configure(type: .withButton, message: "단어장이 모두 찼어요!", actionTitle: "비우러가기")
                toast.action = { [weak self] in
                    self?.navigationController?.popToRootViewController(animated: true)
                }
            }
            .store(in: &cancellables)
    }

    private func showErrorDialog(message: String) {
        dialog.configure(
            style: .error,
            image: UIImage(resource: .imgErrorIos),
            title: "앗! 일시적인 오류가 발생했어요.",
            rightButtonTitle: "확인",
            rightAction: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        )
        dialog.showAnimation()
    }

    func scrollToTop() {
        recommendedExpressionView.scrollToTop()
    }

    func setDate(_ date: String) {
        pendingDate = date
        recommendedExpressionView.setDate(date)
    }
}

// MARK: - BannerViewDelegate

extension RecommendedExpressionViewController: BannerViewDelegate {
    public func bannerViewDidReceiveAd(_ bannerView: BannerView) {
        recommendedExpressionView.setAdBannerView(bannerView)
        bannerView.snp.makeConstraints {
            $0.height.equalTo(bannerView.adSize.size.height)
        }
        self.adPlaceholderImageView.alpha = 0
        self.adPlaceholderImageView.isHidden = true
    }

    public func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
        recommendedExpressionView.removeAdBannerView()
    }
}
