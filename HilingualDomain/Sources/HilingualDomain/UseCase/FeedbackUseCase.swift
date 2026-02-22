//
//  FeedbackUseCase.swift
//  HilingualDomain
//
//  Created by 진소은 on 7/15/25.
//

import Combine

public protocol FeedbackUseCase {
    func fetchFeedback(diaryId: Int) -> AnyPublisher<[DiaryFeedbackEntity], Error>
}

public final class DefaultFeedbackUseCase: FeedbackUseCase {
    private let repository: FeedbackRepository
    
    public init(repository: FeedbackRepository) {
        self.repository = repository
    }
    
    public func fetchFeedback(diaryId: Int) -> AnyPublisher<[DiaryFeedbackEntity], Error> {
        return repository.fetchFeedback(diaryId: diaryId)
    }
}
