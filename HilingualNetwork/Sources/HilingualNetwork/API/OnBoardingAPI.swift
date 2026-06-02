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
    case registerProfile(requestDTO: RegisterProfileRequestDTO)
    case verifyCode(requestDTO: VerifyCodeRequestDTO)
}

extension OnBoardingAPI: BaseTargetType {
    public var path: String {
        switch self {
        case .checkNickname:
            return "/users/profile/check"
        case .registerProfile:
            return "/users/profile"
        case .verifyCode:
            return "/auth/verify"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .checkNickname:
            return .get
        case .registerProfile, .verifyCode:
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

        case .registerProfile(let requestDTO):
            return .requestJSONEncodable(requestDTO)
        case .verifyCode(let requestDTO):
            return .requestJSONEncodable(requestDTO)
        }
    }

    public var headers: [String: String]? {
        var headers = [
            "Content-Type": "application/json",
            "X-Timezone": TimeZone.autoupdatingCurrent.identifier
        ]
        switch self {
        case .registerProfile:
            headers["Authorization"] = "Bearer \(UserDefaultHandler.accessToken)"
        default:
            break
        }
        return headers
    }

    public var sampleData: Data {
        return Data()
    }
}
