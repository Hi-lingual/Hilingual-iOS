//
//  WordBookViewModel.swift
//  HilingualPresentation
//
//  Created by 성현주 on 7/11/25.
//

import Foundation
import Combine

public final class WordBookViewModel: BaseViewModel {

    // MARK: - Input / Output

    public struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
    }

    public struct Output {
        let wordList: AnyPublisher<[(date: String, items: [PhraseData])], Never>
    }
    
    // MARK: - Private

    private let wordListSubject = CurrentValueSubject<[(date: String, items: [PhraseData])], Never>([])

    // MARK: - Transform
    
    public func transform(input: Input) -> Output {
        input.viewDidLoad
            .sink { [weak self] in self?.fetchWords() }
            .store(in: &cancellables)

        return Output(wordList: wordListSubject.eraseToAnyPublisher())
    }

    //usecase 대신 그냥 임시로해둠
    private func fetchWords() {
        let dummy: [(date: String, items: [PhraseData])] = [
            (
                date: "오늘",
                items: [
                    PhraseData(
                        phraseId: 1,
                        phraseType: ["동사", "숙어"],
                        phrase: "come across as",
                        explanation: "어떤 인상을 주다",
                        example: "ㅇ",
                        isMarked: true,
                        created_at: nil
                    ),
                    PhraseData(
                        phraseId: 2,
                        phraseType: ["형용사"],
                        phrase: "underwhelming",
                        explanation: "기대에 못 미치는",
                        example: "The performance was underwhelming.",
                        isMarked: false,
                        created_at: nil
                    ),
                    PhraseData(
                        phraseId: 3,
                        phraseType: ["형용사"],
                        phrase: "spacious",
                        explanation: "넓은",
                        example: "The room is very spacious.",
                        isMarked: true,
                        created_at: nil
                    ),
                    PhraseData(
                        phraseId: 4,
                        phraseType: ["동사"],
                        phrase: "oversleep",
                        explanation: "늦잠 자다",
                        example: "I overslept and missed the bus.",
                        isMarked: false,
                        created_at: nil
                    )
                ]
            ),
            (
                date: "A",
                items: [
                    PhraseData(
                        phraseId: 5,
                        phraseType: ["동사", "구"],
                        phrase: "resonate with",
                        explanation: "공감하다",
                        example: "Her speech resonated with many.",
                        isMarked: false,
                        created_at: nil
                    ),
                    PhraseData(
                        phraseId: 6,
                        phraseType: ["동사", "구"],
                        phrase: "rekindle my interest",
                        explanation: "흥미를 다시 불러일으키다",
                        example: "The movie rekindled my interest in history.",
                        isMarked: false,
                        created_at: nil
                    ),
                    PhraseData(
                        phraseId: 7,
                        phraseType: ["명사", "구"],
                        phrase: "emotional vulnerability",
                        explanation: "감정적 연약함",
                        example: "He showed emotional vulnerability.",
                        isMarked: false,
                        created_at: nil
                    ),
                    PhraseData(
                        phraseId: 8,
                        phraseType: ["부사", "숙어"],
                        phrase: "out of the blue",
                        explanation: "뜻밖에",
                        example: "She called me out of the blue.",
                        isMarked: false,
                        created_at: nil
                    ),
                    PhraseData(
                        phraseId: 9,
                        phraseType: ["형용사", "구"],
                        phrase: "short-lived but impactful",
                        explanation: "짧지만 강렬한",
                        example: "It was a short-lived but impactful experience.",
                        isMarked: false,
                        created_at: nil
                    ),
                    PhraseData(
                        phraseId: 10,
                        phraseType: ["동사", "숙어"],
                        phrase: "ghost",
                        explanation: "잠수타다",
                        example: "He ghosted me after the second date.",
                        isMarked: false,
                        created_at: nil
                    )
                ]
            ),
            (
                date: "30일 전",
                items: [
                    PhraseData(
                        phraseId: 11,
                        phraseType: ["명사"],
                        phrase: "cloud",
                        explanation: "구름",
                        example: "The sky is full of clouds.",
                        isMarked: false,
                        created_at: nil
                    ), PhraseData(
                        phraseId: 6,
                        phraseType: ["동사", "구"],
                        phrase: "rekindle my interest",
                        explanation: "흥미를 다시 불러일으키다",
                        example: "The movie rekindled my interest in history.",
                        isMarked: false,
                        created_at: nil
                    ), PhraseData(
                        phraseId: 6,
                        phraseType: ["동사", "구"],
                        phrase: "rekindle my interest",
                        explanation: "흥미를 다시 불러일으키다",
                        example: "The movie rekindled my interest in history.",
                        isMarked: false,
                        created_at: nil
                    ), PhraseData(
                        phraseId: 6,
                        phraseType: ["동사", "구"],
                        phrase: "rekindle my interest",
                        explanation: "흥미를 다시 불러일으키다",
                        example: "The movie rekindled my interest in history.",
                        isMarked: false,
                        created_at: nil
                    ), PhraseData(
                        phraseId: 6,
                        phraseType: ["동사", "구"],
                        phrase: "rekindle my interest",
                        explanation: "흥미를 다시 불러일으키다",
                        example: "The movie rekindled my interest in history.",
                        isMarked: false,
                        created_at: nil
                    ), PhraseData(
                        phraseId: 6,
                        phraseType: ["동사", "구"],
                        phrase: "rekindle my interest",
                        explanation: "흥미를 다시 불러일으키다",
                        example: "The movie rekindled my interest in history.",
                        isMarked: false,
                        created_at: nil
                    ), PhraseData(
                        phraseId: 6,
                        phraseType: ["동사", "구"],
                        phrase: "rekindle my interest",
                        explanation: "흥미를 다시 불러일으키다",
                        example: "The movie rekindled my interest in history.",
                        isMarked: false,
                        created_at: nil
                    ), PhraseData(
                        phraseId: 6,
                        phraseType: ["동사", "구"],
                        phrase: "rekindle my interest",
                        explanation: "흥미를 다시 불러일으키다",
                        example: "The movie rekindled my interest in history.",
                        isMarked: false,
                        created_at: nil
                    ), PhraseData(
                        phraseId: 6,
                        phraseType: ["동사", "구"],
                        phrase: "rekindle my interest",
                        explanation: "흥미를 다시 불러일으키다",
                        example: "The movie rekindled my interest in history.",
                        isMarked: false,
                        created_at: nil
                    ), PhraseData(
                        phraseId: 6,
                        phraseType: ["동사", "구"],
                        phrase: "rekindle my interest",
                        explanation: "흥미를 다시 불러일으키다",
                        example: "The movie rekindled my interest in history.",
                        isMarked: false,
                        created_at: nil
                    ), PhraseData(
                        phraseId: 6,
                        phraseType: ["동사", "구"],
                        phrase: "rekindle my interest",
                        explanation: "흥미를 다시 불러일으키다",
                        example: "The movie rekindled my interest in history.",
                        isMarked: false,
                        created_at: nil
                    ), PhraseData(
                        phraseId: 6,
                        phraseType: ["동사", "구"],
                        phrase: "rekindle my interest",
                        explanation: "흥미를 다시 불러일으키다",
                        example: "The movie rekindled my interest in history.",
                        isMarked: false,
                        created_at: nil
                    ), PhraseData(
                        phraseId: 6,
                        phraseType: ["동사", "구"],
                        phrase: "rekindle my interest",
                        explanation: "흥미를 다시 불러일으키다",
                        example: "The movie rekindled my interest in history.",
                        isMarked: false,
                        created_at: nil
                    ), PhraseData(
                        phraseId: 6,
                        phraseType: ["동사", "구"],
                        phrase: "rekindle my interest",
                        explanation: "흥미를 다시 불러일으키다",
                        example: "The movie rekindled my interest in history.",
                        isMarked: false,
                        created_at: nil
                    ), PhraseData(
                        phraseId: 6,
                        phraseType: ["동사", "구"],
                        phrase: "rekindle my interest",
                        explanation: "흥미를 다시 불러일으키다",
                        example: "The movie rekindled my interest in history.",
                        isMarked: false,
                        created_at: nil
                    ), PhraseData(
                        phraseId: 6,
                        phraseType: ["동사", "구"],
                        phrase: "rekindle my interest",
                        explanation: "흥미를 다시 불러일으키다",
                        example: "The movie rekindled my interest in history.",
                        isMarked: false,
                        created_at: nil
                    ), PhraseData(
                        phraseId: 6,
                        phraseType: ["동사", "구"],
                        phrase: "rekindle my interest",
                        explanation: "흥미를 다시 불러일으키다",
                        example: "The movie rekindled my interest in history.",
                        isMarked: false,
                        created_at: nil
                    ), PhraseData(
                        phraseId: 6,
                        phraseType: ["동사", "구"],
                        phrase: "rekindle my interest",
                        explanation: "흥미를 다시 불러일으키다",
                        example: "The movie rekindled my interest in history.",
                        isMarked: false,
                        created_at: nil
                    ), PhraseData(
                        phraseId: 6,
                        phraseType: ["동사", "구"],
                        phrase: "rekindle my interest",
                        explanation: "흥미를 다시 불러일으키다",
                        example: "The movie rekindled my interest in history.",
                        isMarked: false,
                        created_at: nil
                    ), PhraseData(
                        phraseId: 6,
                        phraseType: ["동사", "구"],
                        phrase: "rekindle my interest",
                        explanation: "흥미를 다시 불러일으키다",
                        example: "The movie rekindled my interest in history.",
                        isMarked: false,
                        created_at: nil
                    ), PhraseData(
                        phraseId: 6,
                        phraseType: ["동사", "구"],
                        phrase: "rekindle my interest",
                        explanation: "흥미를 다시 불러일으키다",
                        example: "The movie rekindled my interest in history.",
                        isMarked: false,
                        created_at: nil
                    ), PhraseData(
                        phraseId: 6,
                        phraseType: ["동사", "구"],
                        phrase: "rekindle my interest",
                        explanation: "흥미를 다시 불러일으키다",
                        example: "The movie rekindled my interest in history.",
                        isMarked: false,
                        created_at: nil
                    ), PhraseData(
                        phraseId: 6,
                        phraseType: ["동사", "구"],
                        phrase: "rekindle my interest",
                        explanation: "흥미를 다시 불러일으키다",
                        example: "The movie rekindled my interest in history.",
                        isMarked: false,
                        created_at: nil
                    ), PhraseData(
                        phraseId: 6,
                        phraseType: ["동사", "구"],
                        phrase: "rekindle my interest",
                        explanation: "흥미를 다시 불러일으키다",
                        example: "The movie rekindled my interest in history.",
                        isMarked: false,
                        created_at: nil
                    ), PhraseData(
                        phraseId: 6,
                        phraseType: ["동사", "구"],
                        phrase: "rekindle my interest",
                        explanation: "흥미를 다시 불러일으키다",
                        example: "The movie rekindled my interest in history.",
                        isMarked: false,
                        created_at: nil
                    )
                ]
            ),
            (
                date: "5월",
                items: [
                    PhraseData(
                        phraseId: 12,
                        phraseType: ["명사", "숙어"],
                        phrase: "breeze",
                        explanation: "산들바람",
                        example: "A soft breeze cooled the room.",
                        isMarked: false,
                        created_at: nil
                    ),PhraseData(
                        phraseId: 6,
                        phraseType: ["동사", "구"],
                        phrase: "rekindle my interest",
                        explanation: "흥미를 다시 불러일으키다",
                        example: "The movie rekindled my interest in history.",
                        isMarked: false,
                        created_at: nil
                    ), PhraseData(
                        phraseId: 6,
                        phraseType: ["동사", "구"],
                        phrase: "rekindle my interest",
                        explanation: "흥미를 다시 불러일으키다",
                        example: "The movie rekindled my interest in history.",
                        isMarked: false,
                        created_at: nil
                    ), PhraseData(
                        phraseId: 6,
                        phraseType: ["동사", "구"],
                        phrase: "rekindle my interest",
                        explanation: "흥미를 다시 불러일으키다",
                        example: "The movie rekindled my interest in history.",
                        isMarked: false,
                        created_at: nil
                    ), PhraseData(
                        phraseId: 6,
                        phraseType: ["동사", "구"],
                        phrase: "rekindle my interest",
                        explanation: "흥미를 다시 불러일으키다",
                        example: "The movie rekindled my interest in history.",
                        isMarked: false,
                        created_at: nil
                    )
                ]
            ),
            (
                date: "1월",
                items: [
                    PhraseData(
                        phraseId: 13,
                        phraseType: ["형용사"],
                        phrase: "good",
                        explanation: "좋은",
                        example: "It was a good day.",
                        isMarked: false,
                        created_at: nil
                    )
                ]
            ),
            (
                date: "2024",
                items: [
                    PhraseData(
                        phraseId: 14,
                        phraseType: ["명사"],
                        phrase: "snow",
                        explanation: "눈",
                        example: "Snow is falling.",
                        isMarked: false,
                        created_at: nil
                    )
                ]
            )
        ]

        print("보낼 데이터임:", dummy)
        wordListSubject.send(dummy)
    }
}
