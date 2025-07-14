//
//  DefaultWordBookService.swift
//  HilingualNetwork
//
//  Created by 성현주 on 7/13/25.
//

import Foundation
import Combine
import Moya

public protocol WordBookService {
    func fetchWordList(sort: Int) -> AnyPublisher<WordBookResponseWrapperDTO, Error>
    func fetchWordDetail(id: Int) -> AnyPublisher<WordDetailResponseDTO, Error>
    func toggleBookmark(phraseId: Int, isBookmarked: Bool) -> AnyPublisher<Void, Error>

}

public final class DefaultWordBookService: BaseService<WordBookAPI>, WordBookService {
    public func fetchWordDetail(id: Int) -> AnyPublisher<WordDetailResponseDTO, Error> {
        return request(.fetchWordDetail(id: id), as: WordDetailResponseDTO.self)
            .mapError { $0 as Error } 
            .eraseToAnyPublisher()
    }

    public func fetchWordList(sort: Int) -> AnyPublisher<WordBookResponseWrapperDTO, Error> {
        return request(.fetchWordList(sort: sort), as: WordBookResponseWrapperDTO.self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

    public func toggleBookmark(phraseId: Int, isBookmarked: Bool) -> AnyPublisher<Void, Error> {
        return requestPlain(.toggleBookmark(phraseId: phraseId, isBookmarked: isBookmarked))
            .map { _ in () }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
