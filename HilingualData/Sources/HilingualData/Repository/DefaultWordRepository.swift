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
                            explanation: "",     // TODO: API 응답에 포함되면 채워주세요
                            example: nil,         // TODO: API 응답에 포함되면 채워주세요
                            isMarked: false,      // TODO: 북마크 여부, 이후 필드 추가 필요
                            createdAt: nil        // TODO: 날짜 응답 필드 추가되면 채워주세요
                        )
                    }
                    return (group.group, items)
                }
            }
            .eraseToAnyPublisher()
    }
}
