//
//  FeedbackService.swift
//  HilingualNetwork
//
//  Created by 진소은 on 7/15/25.
//

import Foundation

import Moya
import Combine

public protocol FeedbackService {
    func fetchFeedback() -> AnyPublisher<FeedbackResponseDTO, Error>
}

public final class DefaultFeedbackService: BaseService<FeedbackAPI>, FeedbackService {
    public func fetchFeedback() -> AnyPublisher<FeedbackResponseDTO, Error> {
        return request(.fetchFeedback(diaryId: 9), as: FeedbackResponseDTO.self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
