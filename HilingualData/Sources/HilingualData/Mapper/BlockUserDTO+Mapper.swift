//
//  File.swift
//  HilingualData
//
//  Created by 성현주 on 8/21/25.
//

import Foundation

import HilingualDomain
import HilingualNetwork

extension BlockedUserDTO {
    public func toEntity() -> BlockedUserEntity {
        return BlockedUserEntity(
            userId: userId,
            nickname: nickname,
            profileImg: profileImg
        )
    }
}

extension Array where Element == BlockedUserDTO {
    public func toEntityList() -> [BlockedUserEntity] {
        return self.map { $0.toEntity() }
    }
}
