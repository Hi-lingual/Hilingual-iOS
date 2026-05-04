//
//  DefaultTokenRefreshService.swift
//  HilingualNetwork
//
//  Created by 성현주 on 7/15/25.
//

import Foundation
import Combine

import Combine

public protocol TokenRefreshService {
    func refreshToken(_ refreshToken: String) -> AnyPublisher<(accessToken: String, refreshToken: String), Error>
}

public final class DefaultTokenRefreshService: BaseService<AuthAPI>, TokenRefreshService {

    public func refreshToken(_ refreshToken: String) -> AnyPublisher<(accessToken: String, refreshToken: String), Error> {
        return request(.refreshToken(refreshToken: refreshToken), as: BaseAPIResponse<TokenRefreshResponseDTO>.self)
            .tryMap { response in
                let access = response.data.accessToken
                let refresh = response.data.refreshToken
                return (accessToken: access, refreshToken: refresh)
            }
            .eraseToAnyPublisher()
    }
}
