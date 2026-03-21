//
//  AuthService.swift
//  HilingualNetwork
//
//  Created by 성현주 on 7/15/25.
//

import Foundation
import Combine
import UIKit

public protocol AuthService {
    func loginWithApple(token: String) -> AnyPublisher<LoginResponseDTO, Error>
    func refreshToken(token: String) -> AnyPublisher<TokenRefreshResponseDTO, Error>
    func withdraw() -> AnyPublisher<Void, Error>
    func logout() -> AnyPublisher<Void, Error>
}

public final class DefaultAuthService: BaseService<AuthAPI>, AuthService {

    //TODO: - Uikit 의존성 제거하기
    public func loginWithApple(token: String) -> AnyPublisher<LoginResponseDTO, Error> {
        let deviceInfo = CurrentDeviceInfo.make()

        let body = AuthLoginRequestDTO(
            provider: "APPLE",
            role: "USER",
            deviceUuid: deviceInfo.deviceUUID,
            deviceName: deviceInfo.deviceName,
            deviceType: deviceInfo.deviceType,
            osType: deviceInfo.osType,
            osVersion: deviceInfo.osVersion,
            appVersion: deviceInfo.appVersion
        )

        let target = AuthAPI.socialLogin(body: body, providerToken: token)

        return request(target, as: BaseAPIResponse<LoginResponseDTO>.self)
            .tryMap { response in
                return response.data
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

    public func refreshToken(token: String) -> AnyPublisher<TokenRefreshResponseDTO, Error> {
        let target = AuthAPI.refreshToken(refreshToken: token)
        return request(target, as: BaseAPIResponse<TokenRefreshResponseDTO>.self)
            .tryMap { response in
                return response.data
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

    public func withdraw() -> AnyPublisher<Void, Error> {
        return requestPlain(.withdraw)
            .map { _ in }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

    public func logout() -> AnyPublisher<Void, Error> {
        return requestPlain(.logout)
            .map { _ in }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
