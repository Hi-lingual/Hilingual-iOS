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
}

public final class DefaultWordBookService: BaseService<WordBookAPI>, WordBookService {
    public func fetchWordList(sort: Int) -> AnyPublisher<WordBookResponseWrapperDTO, Error> {
        return request(.fetchWordList(sort: sort), as: WordBookResponseWrapperDTO.self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
