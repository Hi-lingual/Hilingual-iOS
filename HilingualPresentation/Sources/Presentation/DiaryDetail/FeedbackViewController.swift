//
//  FeedbackViewController.swift
//  HilingualPresentation
//
//  Created by 진소은 on 7/10/25.
//

import Foundation
import Combine
import UIKit
import GoogleMobileAds
import HilingualCore

// MARK: - Model

struct DiaryViewData {
    let imageURL: String?
    let date: String
    let originalText: String
    let rewriteText: String
    let diffRanges: [HighlightTextView.DiffRange]
    let isHighlightingEnabled: Bool
    let isPublished: Bool
}

struct FeedbackItem {
    let original: String
    let rewrite: String
    let explanation: String
}

public final class FeedbackViewController: BaseUIViewController<FeedbackViewModel>, ScrollControllable {

    // MARK: - Properties

    var onDateLoaded: ((String) -> Void)?
    var publishedInfoLoaded: ((Bool) -> Void)?
    var onToggleChanged: ((Bool) -> Void)?
    private let viewDidLoadSubject = PassthroughSubject<Void, Never>()
    private var date: String = ""

    private var toggleClickCount: Int = 0
    public var page: AnalyticsEvent.Page

    public var showsAdBanner: Bool = false
    private var bannerView: BannerView?
    
    // MARK: - UI Components
    
    private let feedbackView = FeedbackView()
    private let dialog = Dialog()

    private lazy var adPlaceholderImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .imgLoadingFeedIos))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    // MARK: - LifeCycle
    
    public init(viewModel: FeedbackViewModel,
                diContainer: any ViewControllerFactory,
                diaryId: Int,
                page: AnalyticsEvent.Page = .feedback) {
        self.page = page
        super.init(viewModel: viewModel, diContainer: diContainer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadSubject.send(())
        AmplitudeManager.shared.send(.pageviewFeedback(page: self.page))

        feedbackView.onToggleChanged = { [weak self] isEnabled in
            guard let self = self else { return }

            if let customToggleAction = self.onToggleChanged {
                customToggleAction(isEnabled)
            } else {
                self.toggleClickCount += 1
                AmplitudeManager.shared.send(
                    .clickFeedbackToggle(
                        page: self.page,
                        toggleClickCount: self.toggleClickCount,
                        toggleState: isEnabled
                    )
                )
            }
        }
        
        feedbackView.onDiaryPronunciationTapped = { isFirstPlay in
            AmplitudeManager.shared.send(.clickDiaryPronunciationBtn(isFirstPlay: isFirstPlay))
        }
        
        if showsAdBanner {
            setupAdBanner()
        }
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        feedbackView.stopSpeech()
    }

    // MARK: - Custom Method

    public override func setUI() {
        view.addSubviews(feedbackView, dialog)
        view.backgroundColor = .gray100
        view.bringSubviewToFront(dialog)
    }

    public override func setLayout() {
        feedbackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        dialog.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func loadAd() {
        guard let bannerView else { return }

        bannerView.adSize = inlineAdaptiveBanner(width: view.frame.width, maxHeight: 300)

        let request = Request()
        bannerView.load(request)
    }
    
    private func setupAdBanner() {
        let banner = BannerView()
        banner.adUnitID = Bundle.main.infoDictionary?["AD_FEEDBACK_UNIT_ID"] as? String ?? ""
        banner.rootViewController = self
        banner.delegate = self
        self.bannerView = banner
        
        adPlaceholderImageView.alpha = 1
        adPlaceholderImageView.isHidden = false
        feedbackView.setAdBannerView(adPlaceholderImageView)
        adPlaceholderImageView.snp.makeConstraints {
            $0.height.equalTo(160)
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.loadAd()
        }
    }

    // MARK: - Bind

    public override func bind(viewModel: FeedbackViewModel) {
        super.bind(viewModel: viewModel)

        let input = makeInput()
        let output = viewModel.transform(input: input)

        bindOutput(output)
    }

    private func makeInput() -> FeedbackViewModel.Input {
        return FeedbackViewModel.Input(
            viewDidLoad: viewDidLoadSubject.eraseToAnyPublisher()
        )
    }

    private func bindOutput(_ output: FeedbackViewModel.Output) {
        
        output.fetchTopicResult
            .receive(on: RunLoop.main)
            .sink { [weak self] topic in
                self?.feedbackView.setTopic(
                    kor: topic.topicKor,
                    en: topic.topicEn
                )
            }
            .store(in: &cancellables)
        
        output.fetchFeedbackResult
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case let .failure(error) = completion {
                        self?.showErrorDialog(message: error.localizedDescription)
                    }
                },
                receiveValue: { [weak self] feedbackList in
                    self?.errorPresenter.dismiss()
                    let feedbackItems: [FeedbackItem] = feedbackList.map {
                        FeedbackItem(original: $0.original, rewrite: $0.rewrite, explanation: $0.explain)
                    }
                    self?.feedbackView.configureFeedbacks(data: feedbackItems)
                }
            )
            .store(in: &cancellables)

        output.feedbackError
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                guard let self else { return }
                self.errorPresenter.show(error, form: .fullPage, page: .feedback) { [weak self] in
                    self?.viewModel?.fetchFeedback()
                }
            }
            .store(in: &cancellables)

        output.fetchDiaryResult
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case let .failure(error) = completion {
                        self?.showErrorDialog(message: error.localizedDescription)
                    }
                },
                receiveValue: { [weak self] entity in
                    self?.errorPresenter.dismiss()
                    let diffRanges = entity.diffRanges.map {
                        HighlightTextView.DiffRange(
                            start: $0.start,
                            end: $0.end
                        )
                    }

                    let displayDate = DisplayDateFormatter.diaryDetailDate(apiDate: entity.date)

                    let diaryViewData = DiaryViewData(
                        imageURL: entity.image,
                        date: displayDate,
                        originalText: entity.originalText,
                        rewriteText: entity.rewriteText,
                        diffRanges: diffRanges,
                        isHighlightingEnabled: true,
                        isPublished: entity.isPublished
                    )
                    self?.date = displayDate
                    self?.onDateLoaded?(displayDate)
                    self?.publishedInfoLoaded?(entity.isPublished)

                    self?.feedbackView.configureDiary(data: diaryViewData)
                }
            )
            .store(in: &cancellables)

        output.diaryDetailError
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                self?.errorPresenter.show(error, form: .fullPage, page: .feedback) { [weak self] in
                    self?.viewModel?.fetchDiaryDetail()
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
        feedbackView.scrollToTop()
    }
}

// MARK: - BannerViewDelegate

extension FeedbackViewController: BannerViewDelegate {
    public func bannerViewDidReceiveAd(_ bannerView: BannerView) {
        feedbackView.setAdBannerView(bannerView)
        bannerView.snp.makeConstraints {
            $0.height.equalTo(bannerView.adSize.size.height)
        }
        self.adPlaceholderImageView.alpha = 0
        self.adPlaceholderImageView.isHidden = true
    }

    public func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
        feedbackView.removeAdBannerView()
    }
}
