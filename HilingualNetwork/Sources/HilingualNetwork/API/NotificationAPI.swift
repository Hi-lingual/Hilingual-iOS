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
    case getNotifications(tab: String)
    case getNotificationDetail(id: Int)
    case markAsRead(id: Int)
}

extension NotificationAPI: BaseTargetType {

    public var path: String {
        switch self {
        case .fetchNotificationSettings, .toggleNotificationSetting:
            return "/users/mypage/noti"

        case .getNotifications:
            return "/users/notifications"

        case .getNotificationDetail(let id):
            return "/users/notifications/\(id)"

        case .markAsRead(let id):
            return "/users/notifications/\(id)/read"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .fetchNotificationSettings, .getNotifications, .getNotificationDetail:
            return .get

        case .toggleNotificationSetting, .markAsRead:
            return .patch
        }
    }

    public var task: Task {
        switch self {
        case .fetchNotificationSettings, .getNotificationDetail, .markAsRead:
            return .requestPlain

        case let .toggleNotificationSetting(notiType):
            return .requestParameters(
                parameters: ["notiType": notiType],
                encoding: URLEncoding.queryString
            )

        case let .getNotifications(tab):
            return .requestParameters(
                parameters: ["tab": tab],
                encoding: URLEncoding.queryString
            )
        }
    }
}
