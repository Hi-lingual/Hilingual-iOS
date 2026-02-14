//
//  MockRecommendedUseCase.swift
//  HilingualDomain
//
//  Created by 진소은 on 8/4/25.
//


import Combine

public final class MockRecommendedUseCase: RecommendedExpressionUseCase {
    private let returnEmpty: Bool

    public init(returnEmpty: Bool = false) {
        self.returnEmpty = returnEmpty
    }

    public func fetchRecommendedExpression(diaryId: Int) -> AnyPublisher<[RecommendedExpressionEntity.Phrase], Error> {
        let dummyList: [RecommendedExpressionEntity.Phrase] = returnEmpty ? [] : [
            RecommendedExpressionEntity.Phrase(
                phraseId: 1,
                phraseType: ["동사", "일상 표현"],
                phrase: "take a walk",
                explanation: "산책하다",
                reason: "‘산책했다’는 문장에서 자연스럽게 사용할 수 있어요.",
                isBookmarked: false
            ),
            RecommendedExpressionEntity.Phrase(
                phraseId: 2,
                phraseType: ["형용사"],
                phrase: "exhausted",
                explanation: "지친, 기진맥진한",
                reason: "‘피곤했다’는 표현을 더 생생하게 전달할 수 있어요.",
                isBookmarked: true
            )
        ]

        return Just(dummyList)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
