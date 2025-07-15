//
//  OnBoardingAPI.swift
//  HilingualNetwork
//
//  Created by 성현주 on 7/9/25.
//

import Foundation
import Moya

public enum OnBoardingAPI {
    case checkNickname(nickname: String)
    case setProfile(nickname: String, profileImg: String) 
}

extension OnBoardingAPI: TargetType {

    public var baseURL: URL {
        return NetworkEnvironment.shared.baseURL
    }

    public var path: String {
        switch self {
        case .checkNickname, .setProfile:
            return "/users/profile"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .checkNickname:
            return .get
        case .setProfile:
            return .post
        }
    }

    public var task: Task {
        switch self {
        case .checkNickname(let nickname):
            return .requestParameters(
                parameters: ["nickname": nickname],
                encoding: URLEncoding.default
            )

        case .setProfile(let nickname, let profileImg):
            return .requestParameters(
                parameters: [
                    "nickname": nickname,
                    "profileImg": profileImg
                ],
                encoding: JSONEncoding.default
            )
        }
    }

    public var headers: [String: String]? {
        switch self {
        case .checkNickname:
            return ["Content-Type": "application/json"]

        case .setProfile:
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(UserDefaultHandler.accessToken)"
            ]
        }
    }

    public var sampleData: Data {
        return Data()
    }
}
