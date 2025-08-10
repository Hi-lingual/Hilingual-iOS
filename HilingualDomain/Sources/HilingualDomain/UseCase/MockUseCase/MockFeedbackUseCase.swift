//
//  MockFeedbackUseCase.swift
//  HilingualDomain
//
//  Created by 진소은 on 8/3/25.
//


import Combine

public final class MockFeedbackUseCase: FeedbackUseCase {
    public init() {}

    public func fetchFeedback(diaryId: Int) -> AnyPublisher<[DiaryFeedbackEntity], Error> {
        let dummyFeedbackList = [
            DiaryFeedbackEntity(
                original: "I goes to school",
                rewrite: "I go to school",
                explain: "'goes'는 'I'와 어울리지 않으므로 'go'로 수정해야 합니다."
            ),
            DiaryFeedbackEntity(
                original: "eat lunch with friends",
                rewrite: "have lunch with friends",
                explain: "'have lunch'가 더 자연스러운 표현입니다."
            )
        ]
        return Just(dummyFeedbackList)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
