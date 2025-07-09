//
//  BookmarkService.swift
//  HilingualNetwork
//
//  Created by 진소은 on 7/9/25.
//

import Foundation

import Moya
import Combine

public protocol BookmarkService {
    func setBookmark(phraseId: Int64) -> AnyPublisher<BookmarkDTO, Error>
}

// TODO: - 추후 API 연동 시 구현

public final class DefaultBookmarkService: BookmarkService {
    public func setBookmark(phraseId: Int64) -> AnyPublisher<BookmarkDTO, Error> {
        fatalError("BookmarkService 구현X")
    }
}
