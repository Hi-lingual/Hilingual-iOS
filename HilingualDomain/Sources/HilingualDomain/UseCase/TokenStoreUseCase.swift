//
//  TokenStoreUseCase.swift
//  HilingualDomain
//
//  Created by 성현주 on 7/15/25.
//

public protocol TokenStoreUseCase {
    func save(accessToken: String, refreshToken: String)
    func clear()
    func loadAccessToken() -> String
}
