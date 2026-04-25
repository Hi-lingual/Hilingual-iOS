//
//  MockDiaryDetailUseCase.swift
//  HilingualDomain
//
//  Created by 진소은 on 8/3/25.
//


import Combine

public final class MockDiaryDetailUseCase: DiaryDetailUseCase {
    public init() {}

    public func fetchDiaryDetail(diaryId: Int) -> AnyPublisher<DiaryDetailEntity, Error> {
        let dummyDetail = DiaryDetailEntity(
            date: "2025-08-03",
            image: "https://avatars.githubusercontent.com/u/42905243?v=4",
            originalText: "I goes to school every day and eat lunch with friends.",
            rewriteText: "I go to school every day and have lunch with friends.",
            diffRanges: [
                .init(start: 2, end: 6, correctedText: "go"),   // "goes" → "go"
                .init(start: 39, end: 42, correctedText: "have") // "eat" → "have"
            ],
            isPublished: false,
            isAdWatched: true
        )
        return Just(dummyDetail)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
