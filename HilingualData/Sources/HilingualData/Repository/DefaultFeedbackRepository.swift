//
//  DefaultFeedbackRepository.swift
//  HilingualData
//
//  Created by 진소은 on 7/15/25.
//

import Combine

import HilingualDomain
import HilingualNetwork

public final class DefaultFeedbackRepository: FeedbackRepository {
    
    private let service: FeedbackService
    
    public init(service: FeedbackService) {
        self.service = service
    }
    
    public func fetchFeedback(diaryId: Int) -> AnyPublisher<[DiaryFeedbackEntity], any Error> {
        return service.fetchFeedback(diaryId: diaryId)
            .map { dto in
                dto.data.feedbackList.map {
                    DiaryFeedbackEntity(
                        original: $0.original,
                        rewrite: $0.rewrite,
                        explain: $0.explain
                    )
                }
            }
            .eraseToAnyPublisher()
    }
}
