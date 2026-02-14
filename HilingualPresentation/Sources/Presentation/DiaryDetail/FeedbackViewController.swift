//
//  FeedbackViewController.swift
//  HilingualPresentation
//
//  Created by 진소은 on 7/10/25.
//

import Foundation
import Combine
import UIKit

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

    private var date: String = ""

    private let feedbackView = FeedbackView()
    private let dialog = Dialog()

    private let viewDidLoadSubject = PassthroughSubject<Void, Never>()

    // MARK: - LifeCycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadSubject.send(())

        // 토글 콜백 연결
        feedbackView.onToggleChanged = { [weak self] isEnabled in
            self?.onToggleChanged?(isEnabled)
        }
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
    }

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
        output.fetchFeedbackResult
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case let .failure(error) = completion {
                        self?.showErrorDialog(message: error.localizedDescription)
                    }
                },
                receiveValue: { [weak self] feedbackList in
                    let feedbackItems: [FeedbackItem] = feedbackList.map {
                        FeedbackItem(original: $0.original, rewrite: $0.rewrite, explanation: $0.explain)
                    }
                    self?.feedbackView.configureFeedbacks(data: feedbackItems)
                }
            )
            .store(in: &cancellables)

        output.fetchDiaryResult
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case let .failure(error) = completion {
                        // 에러 처리
                        self?.showErrorDialog(message: error.localizedDescription)
                    }
                },
                receiveValue: { [weak self] entity in
                    let diffRanges = entity.diffRanges.map {
                        HighlightTextView.DiffRange(
                            start: $0.start,
                            end: $0.end
                        )
                    }

                    let diaryViewData = DiaryViewData(
                        imageURL: entity.image,
                        date: entity.date,
                        originalText: entity.originalText,
                        rewriteText: entity.rewriteText,
                        diffRanges: diffRanges,
                        isHighlightingEnabled: true,
                        isPublished: entity.isPublished
                    )
                    self?.date = entity.date
                    self?.onDateLoaded?(entity.date)
                    self?.publishedInfoLoaded?(entity.isPublished)

                    self?.feedbackView.configureDiary(data: diaryViewData)
                }
            )
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
