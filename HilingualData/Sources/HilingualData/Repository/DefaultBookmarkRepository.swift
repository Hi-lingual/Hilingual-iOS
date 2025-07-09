//
//  DefaultBookmarkRepository.swift
//  HilingualData
//
//  Created by 진소은 on 7/9/25.
//

import Combine

import HilingualDomain
import HilingualNetwork

public final class DefaultBookmarkRepository: BookmarkRepository {
    private var service: BookmarkService
    
    public init(service: BookmarkService) {
        self.service = service
    }
    
    public func setBookmark(phraseId: Int64) -> AnyPublisher<PhraseEntity, any Error> {
        service.setBookmark(phraseId: phraseId)
        
    }
}
