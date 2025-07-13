//
//  WordBookViewModel.swift
//  HilingualPresentation
//
//  Created by 성현주 on 7/11/25.
//

import Foundation
import Combine
import HilingualDomain

public final class WordBookViewModel: BaseViewModel {

    // MARK: - Input / Output

    public struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let sortChanged: AnyPublisher<SortOption, Never>
    }

    public struct Output {
        let wordList: AnyPublisher<[(date: String, items: [PhraseData])], Never>
    }

    // MARK: - Dependencies

    private let fetchWordListUseCase: WordBookUseCase

    // MARK: - State

    private let wordListSubject = CurrentValueSubject<[(date: String, items: [PhraseData])], Never>([])
    private var currentSortOption: SortOption = .alphabetical

    // MARK: - Init

    public init(fetchWordListUseCase: WordBookUseCase) {
        self.fetchWordListUseCase = fetchWordListUseCase
    }

    // MARK: - Transform

    public func transform(input: Input) -> Output {
        input.viewDidLoad
            .sink { [weak self] in
                self?.fetchWords(sort: self?.currentSortOption ?? .alphabetical)
            }
            .store(in: &cancellables)

        input.sortChanged
            .sink { [weak self] option in
                self?.currentSortOption = option
                self?.fetchWords(sort: option)
            }
            .store(in: &cancellables)

        return Output(wordList: wordListSubject.eraseToAnyPublisher())
    }

    // MARK: - Fetch

//    private func fetchWords(sort: SortOption) {
//        fetchWordListUseCase.execute(sort: sort)
//            .map { wordList in
//                wordList.map { (date, items) in
//                    let phraseDataList = items.map { entity in
//                        PhraseData(
//                            phraseId: entity.phraseId,
//                            phraseType: entity.phraseType,
//                            phrase: entity.phrase,
//                            explanation: entity.explanation,
//                            example: entity.example,
//                            isMarked: entity.isMarked,
//                            created_at: entity.createdAt
//                        )
//                    }
//                    return (date: date, items: phraseDataList)
//                }
//            }
//            .replaceError(with: [])
//            .sink { [weak self] result in
//                self?.wordListSubject.send(result)
//            }
//            .store(in: &cancellables)
//    }

    private func fetchWords(sort: SortOption) {
        // 임시 테스트용 빈 배열 주입
        let emptyList: [(String, [WordEntity])] = []

        let emptyPhraseData: [(String, [PhraseData])] = emptyList.map { (date, entities) in
            let mapped = entities.map { entity in
                PhraseData(
                    phraseId: entity.phraseId,
                    phraseType: entity.phraseType,
                    phrase: entity.phrase,
                    explanation: entity.explanation,
                    example: entity.example,
                    isMarked: entity.isMarked,
                    created_at: entity.createdAt
                )
            }
            return (date, mapped)
        }

        self.wordListSubject.send(emptyPhraseData)
    }
}
