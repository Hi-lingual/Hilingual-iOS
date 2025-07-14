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

    public func fetchWords(sort: SortOption) -> AnyPublisher<[(date: String, items: [WordEntity])], Error> {
        return service.fetchWordList(sort: sort.rawValue)
            .map { wrapperDTO in
                wrapperDTO.data.wordList.map { group in
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

    public func fetchWordDetail(id: Int) -> AnyPublisher<WordEntity, Error> {
        return service.fetchWordDetail(id: id)
            .map { dto in
                WordEntity(
                    phraseId: dto.phraseId,
                    phraseType: dto.phraseType,
                    phrase: dto.phrase,
                    explanation: dto.explaination,
                    example: nil,
                    isMarked: false,
                    createdAt: dto.created_at
                )
            }
            .eraseToAnyPublisher()
    }

    public func toggleBookmark(phraseId: Int, isBookmarked: Bool) -> AnyPublisher<Void, Error> {
            return service.toggleBookmark(phraseId: phraseId, isBookmarked: isBookmarked)
        }

}
