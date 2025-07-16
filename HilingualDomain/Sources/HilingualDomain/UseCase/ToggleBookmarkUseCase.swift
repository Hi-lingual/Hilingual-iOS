//
//  ToggleBookmarkUseCase.swift
//  HilingualDomain
//
//  Created by 성현주 on 7/14/25.
//

import Foundation
import Combine

public protocol ToggleBookmarkUseCase {
    func execute(phraseId: Int, isBookmarked: Bool) -> AnyPublisher<Void, Error>
}

public final class DefaultToggleBookmarkUseCase: ToggleBookmarkUseCase {
    private let repository: WordBookRepository

    public init(repository: WordBookRepository) {
        self.repository = repository
    }

    public func execute(phraseId: Int, isBookmarked: Bool) -> AnyPublisher<Void, Error> {
        return repository.toggleBookmark(phraseId: phraseId, isBookmarked: isBookmarked)
    }
}
