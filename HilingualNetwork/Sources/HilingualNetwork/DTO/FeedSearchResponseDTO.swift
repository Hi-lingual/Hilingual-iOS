//
//  FeedSearchResponseDTO.swift
//  HilingualNetwork
//
//  Created by 신혜연 on 8/29/25.
//

import Foundation

public struct UserListDataDTO: Decodable {
    public let userList: [UserDTO]
}

public struct UserDTO: Decodable {
    public let userId: Int
    public let profileImg: String
    public let nickname: String
    public let isFollowing: Bool
    public let isFollowed: Bool
}
