//
//  BookmarkRequestDTO.swift
//  HilingualNetwork
//
//  Created by 성현주 on 7/14/25.
//

import Foundation

public struct BookmarkRequestDTO: Encodable {
    public let isBookmarked: Bool

    public init(isBookmarked: Bool) {
        self.isBookmarked = isBookmarked
    }
}
