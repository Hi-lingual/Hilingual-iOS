//
//  BlockListDTO.swift
//  HilingualNetwork
//
//  Created by 성현주 on 8/21/25.
//

import Foundation

public struct BlockedUserListResponseDTO: Decodable {
    public let blockList: [BlockedUserDTO]
}

public struct BlockedUserDTO: Decodable {
    public let userId: Int
    public let profileImg: String
    public let nickname: String
}

extension BlockedUserListResponseDTO {
    public static var sampleData: Self {
        return .init(
            blockList: [
                .init(userId: 1, profileImg: "https://cdn.example.com/profile1.png", nickname: "하징니"),
                .init(userId: 2, profileImg: "https://cdn.example.com/profile1.png", nickname: "조잉주"),
                .init(userId: 3, profileImg: "https://cdn.example.com/profile3.png", nickname: "하링구")
            ]
        )
    }
}
