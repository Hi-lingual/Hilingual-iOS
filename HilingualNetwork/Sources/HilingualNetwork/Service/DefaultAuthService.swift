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
}

public final class DefaultAuthService: BaseService<AuthAPI>, AuthService {

    public func loginWithApple(token: String) -> AnyPublisher<LoginResponseDTO, Error> {
//        #if DEBUG
//        let dummyResponse = LoginResponseDTO(
//            accessToken: "debug_access_token",
//            refreshToken: "debug_refresh_token",
//            isProfileCompleted: false
//        )
//        return Just(dummyResponse)
//            .setFailureType(to: Error.self)
//            .eraseToAnyPublisher()
//        #else
        let body = AuthLoginRequestDTO(
            provider: "APPLE",
            role: "USER",
            deviceName: UIDevice.current.name,
            deviceType: {
                #if targetEnvironment(macCatalyst)
                return "DESKTOP"
                #elseif os(iOS)
                return UIDevice.current.userInterfaceIdiom == .pad ? "TABLET" : "PHONE"
                #else
                return "UNKNOWN"
                #endif
            }(),
            osType: UIDevice.current.systemName,
            osVersion: UIDevice.current.systemVersion,
            appVersion: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown"
        )

        let target = AuthAPI.socialLogin(body: body, providerToken: token)

        return request(target, as: BaseAPIResponse<LoginResponseDTO>.self)
            .tryMap { response in
                return response.data
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
//        #endif
    }

    public func refreshToken(token: String) -> AnyPublisher<TokenRefreshResponseDTO, Error> {
//        #if DEBUG
//        let dummyResponse = TokenRefreshResponseDTO(
//            accessToken: "debug_refreshed_access_token",
//            refreshToken: "debug_refreshed_refresh_token"
//        )
//        return Just(dummyResponse)
//            .setFailureType(to: Error.self)
//            .eraseToAnyPublisher()
//        #else
        let target = AuthAPI.refreshToken(refreshToken: token)
        return request(target, as: BaseAPIResponse<TokenRefreshResponseDTO>.self)
            .tryMap { response in
                return response.data
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
//        #endif
    }
    public func withdraw() -> AnyPublisher<Void, Error> {
        return requestPlain(.withdraw)
            .map { _ in }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
