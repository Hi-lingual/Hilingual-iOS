//
//  LoginResponseDTO+Mapper.swift
//  HilingualData
//
//  Created by 성현주 on 7/15/25.
//

import Foundation

import HilingualDomain
import HilingualNetwork

extension LoginResponseDTO {
    public func toEntity() -> LoginResponseEntity {
        return LoginResponseEntity(
            accessToken: self.accessToken,
            refreshToken: self.refreshToken,
            isProfileCompleted: self.registerStatus
        )
    }
}
