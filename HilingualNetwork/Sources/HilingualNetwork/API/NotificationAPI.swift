//
//  NotificationAPI.swift
//  HilingualNetwork
//
//  Created by 성현주 on 9/7/25.
//


import Moya

public enum NotificationAPI {
    case fetchNotificationSettings
}

extension NotificationAPI: BaseTargetType {
    
    public var path: String {
        switch self {
        case .fetchNotificationSettings:
            return "/users/mypage/noti"
        }
    }

    public var method: Moya.Method {
        return .get
    }

    public var task: Task {
        return .requestPlain
    }
}
