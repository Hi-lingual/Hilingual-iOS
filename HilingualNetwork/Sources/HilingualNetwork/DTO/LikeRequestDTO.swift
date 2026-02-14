//
//  LikeRequestDTO.swift
//  HilingualNetwork
//
//  Created by 진소은 on 8/26/25.
//

import Foundation

public struct LikeRequestDTO: Encodable {
    public let isLiked: Bool
    
    public init(isLiked: Bool) {
        self.isLiked = isLiked
    }
}
