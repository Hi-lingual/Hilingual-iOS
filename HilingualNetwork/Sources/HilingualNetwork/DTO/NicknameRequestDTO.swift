//
//  NicknameRequestDTO.swift
//  HilingualNetwork
//
//  Created by 성현주 on 5/16/26.
//

import Foundation

public struct NicknameRequestDTO: Encodable {
    public let nickname: String

    public init(nickname: String) {
        self.nickname = nickname
    }
}
