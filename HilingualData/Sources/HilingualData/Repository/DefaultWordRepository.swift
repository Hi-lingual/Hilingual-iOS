//
//  DefaultWordRepository.swift
//  HilingualData
//
//  Created by 성현주 on 7/13/25.
//

import Foundation
import Combine

import HilingualDomain
import HilingualNetwork

public final class DefaultWordRepository: WordBookRepository {

    private let service: WordBookService

    public init(service: WordBookService) {
        self.service = service
    }

    //MARK: - 디티오 수정슨 필요슨
    public func fetchWords(sort: SortOption) -> AnyPublisher<[(date: String, items: [WordEntity])], Error> {
        return service.fetchWordList(sort: sort.rawValue)
            .map { dto in
                dto.wordList.map { group in
                    let items: [WordEntity] = group.words.map { wordDTO in
                        WordEntity(
                            phraseId: wordDTO.phraseId,
                            phraseType: wordDTO.phraseType,
                            phrase: wordDTO.phrase,
                            explanation: "",
                            example: nil,
                            isMarked: false,
                            createdAt: nil
                        )
                    }
                    return (group.group, items)
                }
            }
            .eraseToAnyPublisher()
    }
}
