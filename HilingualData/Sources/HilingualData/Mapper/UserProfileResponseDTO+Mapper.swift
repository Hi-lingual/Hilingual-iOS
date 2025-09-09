//
//  UserProfileResponseDTO+Mapper.swift
//  HilingualData
//
//  Created by 성현주 on 9/9/25.
//

import Foundation

import HilingualNetwork
import HilingualDomain

extension UserProfileResponseDTO {
    public func toEntity() -> UserProfileEntity {
        return UserProfileEntity(
            profileImg: self.profileImg,
            nickname: self.nickname,
            provider: self.provider
        )
    }
}
