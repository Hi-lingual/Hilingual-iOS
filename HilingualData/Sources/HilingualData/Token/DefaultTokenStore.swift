//
//  DefaultTokenStore.swift
//  HilingualData
//
//  Created by 성현주 on 7/15/25.
//

import HilingualDomain
import HilingualNetwork

public final class DefaultTokenStore: TokenStoreUseCase {
    public init() {}

    public func save(accessToken: String, refreshToken: String) {
        UserDefaultHandler.accessToken = accessToken
        UserDefaultHandler.refreshToken = refreshToken
    }

    public func clear() {
        UserDefaultHandler.accessToken = ""
        UserDefaultHandler.refreshToken = ""
    }

    public func loadAccessToken() -> String {
        return UserDefaultHandler.accessToken
    }
}
