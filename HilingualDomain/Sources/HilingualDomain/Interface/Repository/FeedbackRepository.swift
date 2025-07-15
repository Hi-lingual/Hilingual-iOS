//
//  FeedbackRepository.swift
//  HilingualDomain
//
//  Created by 진소은 on 7/15/25.
//

import Combine

public protocol FeedbackRepository {
    func fetchFeedback() -> AnyPublisher<[DiaryFeedbackEntity], Error>
}
