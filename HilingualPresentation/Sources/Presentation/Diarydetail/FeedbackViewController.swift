//
//  FeedbackViewController.swift
//  HilingualPresentation
//
//  Created by 진소은 on 7/10/25.
//

import Foundation

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
    init(original: String, rewrite: String, explanation: String) {
            self.original = original
            self.rewrite = rewrite
            self.explanation = explanation
        }
}

public final class FeedbackViewController: BaseUIViewController<FeedbackViewModel> {
    
    // MARK: - Properties
    
    private let feedbackView = FeedbackView()
    
    // MARK: - LifeCycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let feedbackItems: [FeedbackItem] = dummyFeedbackData.data.map {
            FeedbackItem(
                original: $0.originalText,
                rewrite: $0.rewriteText,
                explanation: $0.explanation
            )
        }
        feedbackView.configureFeedbacks(data: feedbackItems)

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
}
