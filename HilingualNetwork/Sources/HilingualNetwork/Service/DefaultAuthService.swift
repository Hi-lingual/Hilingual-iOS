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
