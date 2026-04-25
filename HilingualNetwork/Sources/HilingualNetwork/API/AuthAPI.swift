//
//  AuthAPI.swift
//  HilingualNetwork
//
//  Created by 성현주 on 7/15/25.
//

import Foundation
import Moya

public enum AuthAPI {
    case socialLogin(body: AuthLoginRequestDTO, providerToken: String)
    case refreshToken(refreshToken: String)
    case withdraw
    case logout
}

extension AuthAPI: NoAuthorizeTargetType {
    public var path: String {
        switch self {
        case .socialLogin:
            return "/auth/login"
        case .refreshToken:
            return "/users/reissue"
        case .withdraw:
            return "/auth/leave"
        case .logout:
            return "/auth/logout"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .socialLogin:
            return .post
        case .refreshToken:
            return .post
        case .withdraw:
            return .post
        case .logout:
            return .post
        }
    }

    public var task: Task {
        switch self {
        case let .socialLogin(body, _):
            return .requestJSONEncodable(body)
        case .refreshToken:
            return .requestPlain
        case .withdraw:
            return .requestPlain
        case .logout:
            return .requestPlain
        }
    }

    public var headers: [String: String]? {
        switch self {
        case let .socialLogin(_, providerToken):
            return [
                "Content-Type": "application/json",
                "Provider-Token": providerToken,
                "X-Timezone": TimeZone.autoupdatingCurrent.identifier
            ]
        case let .refreshToken(refreshToken):
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(refreshToken)",
                "X-Timezone": TimeZone.autoupdatingCurrent.identifier
            ]
        case .withdraw:
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(UserDefaultHandler.accessToken)",
                "X-Timezone": TimeZone.autoupdatingCurrent.identifier
            ]
        case .logout:
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(UserDefaultHandler.accessToken)",
                "X-Timezone": TimeZone.autoupdatingCurrent.identifier
            ]
        }
    }
}
