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

public final class FeedbackViewController: BaseUIViewController<FeedbackViewModel> {
    
    // MARK: - Properties
    
    private let feedbackView = FeedbackView()
    
    // MARK: - LifeCycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let diaryContent = dummyCorrectionData.data
        let diffRanges = diaryContent.diffRanges.map {
            HighlightTextView.DiffRange(start: $0.start, end: $0.end)
        }
        
        let diaryData = DiaryViewData(
            imageURL: diaryContent.image,
            date: diaryContent.date,
            originalText: diaryContent.originalText,
            rewriteText: diaryContent.rewriteText,
            diffRanges: diffRanges,
            isHighlightingEnabled: true
        )
        
        feedbackView.configureDiary(data: diaryData)
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
        output.fetchDiaryResult
            .receive(on: RunLoop.main)
            .sink { [weak self] feedbackList in
                let feedbackItems: [FeedbackItem] = feedbackList.map {
                    FeedbackItem(original: $0.original, rewrite: $0.rewrite, explanation: $0.explain)
                }
                self?.feedbackView.configureFeedbacks(data: feedbackItems)            }
            .store(in: &cancellables)
    }
}
