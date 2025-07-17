//
//  FeedbackViewController.swift
//  HilingualPresentation
//
//  Created by 진소은 on 7/10/25.
//

import Foundation
import Combine

// MARK: - Model

struct DiaryViewData {
    let imageURL: String?
    let date: String
    let originalText: String
    let rewriteText: String
    let diffRanges: [HighlightTextView.DiffRange]
    let isHighlightingEnabled: Bool
}

struct FeedbackItem {
    let original: String
    let rewrite: String
    let explanation: String
}

public final class FeedbackViewController: BaseUIViewController<FeedbackViewModel>, ScrollControllable {
    
    // MARK: - Properties
    
    var onDateLoaded: ((String) -> Void)?
    
    private let feedbackView = FeedbackView()
    private var date: String = ""
    
    // MARK: - LifeCycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Custom Method
    
    public override func setUI() {
        view.addSubview(feedbackView)
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
            viewDidLoad: Just(()).eraseToAnyPublisher()
        )
    }
    
    private func bindOutput(_ output: FeedbackViewModel.Output) {
        output.fetchFeedbackResult
            .receive(on: RunLoop.main)
            .sink { [weak self] feedbackList in
                let feedbackItems: [FeedbackItem] = feedbackList.map {
                    FeedbackItem(original: $0.original, rewrite: $0.rewrite, explanation: $0.explain)
                }
                self?.feedbackView.configureFeedbacks(data: feedbackItems)            }
            .store(in: &cancellables)
        
        output.fetchDiaryResult
            .receive(on: RunLoop.main)
            .sink { [weak self] entity in
                let diffRanges = entity.diffRanges.map {
                    HighlightTextView.DiffRange(
                        start: $0.start,
                        end: $0.end,
                    )
                }
                
                let diaryViewData = DiaryViewData(
                    imageURL: entity.image,
                    date: entity.date,
                    originalText: entity.originalText,
                    rewriteText: entity.rewriteText,
                    diffRanges: diffRanges,
                    isHighlightingEnabled: true
                )
                self?.date = entity.date
                self?.onDateLoaded?(entity.date)
                
                self?.feedbackView.configureDiary(data: diaryViewData)

            }
            .store(in: &cancellables)
    }
    
    func scrollToTop() {
        feedbackView.scrollToTop()
    }
}
