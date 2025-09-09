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

//
//  NotificationAPI.swift
//  HilingualNetwork
//
//  Created by 성현주 on 9/9/25.
//

import Moya

public enum NotificationAPI {
    case getNotifications(tab: String)
}

extension NotificationAPI: BaseTargetType {
    public var path: String {
        return "/users/notifications"
    }

    public var method: Moya.Method {
        return .get
    }

    public var task: Task {
        switch self {
        case .getNotifications(let tab):
            return .requestParameters(parameters: ["tab": tab], encoding: URLEncoding.queryString)
        }
    }
}
