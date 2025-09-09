//
//  NotificationAPI.swift
//  HilingualNetwork
//
//  Created by 성현주 on 9/7/25.
//

import Moya

public enum NotificationAPI {
    case fetchNotificationSettings
    case toggleNotificationSetting(notiType: String)
}

extension NotificationAPI: BaseTargetType {

    public var path: String {
        return "/users/mypage/noti"
    }

    public var method: Moya.Method {
        switch self {
        case .fetchNotificationSettings:
            return .get
        case .toggleNotificationSetting:
            return .patch
        }
    }

    public var task: Task {
        switch self {
        case .fetchNotificationSettings:
            return .requestPlain

        case let .toggleNotificationSetting(notiType):
            return .requestParameters(
                parameters: ["notiType": notiType],
                encoding: URLEncoding.queryString
            )
        }
    }

    public var headers: [String: String]? {
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(UserDefaultHandler.accessToken)"
        ]
    }
}
