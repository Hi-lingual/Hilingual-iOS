//
//  FeedProfileInfoDTO.swift
//  HilingualNetwork
//
//  Created by 조영서 on 8/26/25.
//

import Foundation

public struct FeedProfileInfoResponseDTO: Decodable {
    public let code: Int
    public let data: FeedProfileInfoDTO
    public let message: String
}

public struct FeedProfileInfoDTO: Decodable {
    public let userId: Int
    public let isMine: Bool
    public let profileImg: String
    public let nickname: String
    public let follower: Int
    public let following: Int
    public let streak: Int
    public let isFollowing: Bool?
    public let isFollowed: Bool?
    public let isBlocked: Bool?
}
