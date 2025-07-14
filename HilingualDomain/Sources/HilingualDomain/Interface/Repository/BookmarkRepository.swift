//
//  BookmarkRepository.swift
//  HilingualDomain
//
//  Created by 진소은 on 7/9/25.
//

import Combine

public protocol BookmarkRepository {
    func setBookmark(phraseId: Int64) -> AnyPublisher<PhraseEntity, Error>
}
