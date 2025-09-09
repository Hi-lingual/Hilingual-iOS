//
//  UnfollowResponseDTO.swift
//  HilingualNetwork
//
//  Created by 신혜연 on 9/9/25.
//

import Foundation

public struct UnfollowResponseDTO: Decodable {
    public let code: Int
    public let data: UnfollowDataDTO
    public let message: String
}

public struct UnfollowDataDTO: Decodable {
    public let followedBy: Bool
}
