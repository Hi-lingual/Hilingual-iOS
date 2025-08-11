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
            date: "8월 3일 일요일",
            image: "https://cdn.discordapp.com/attachments/839608563776094232/1404184128202735636/test_image.png?ex=689a43e0&is=6898f260&hm=9f3a4d70b83e4b4742652e82c18494990030cc53a62e5d8f72fd1e2131daafd0&",
//            image: "https://avatars.githubusercontent.com/u/42905243?v=4",
            originalText: "I goes to school every day and eat lunch with friends.",
            rewriteText: "I go to school every day and have lunch with friends.",
            diffRanges: [
                .init(start: 2, end: 6, correctedText: "go"),   // "goes" → "go"
                .init(start: 39, end: 42, correctedText: "have") // "eat" → "have"
            ]
        )
        return Just(dummyDetail)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
