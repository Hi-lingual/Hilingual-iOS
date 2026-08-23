//
//  WidgetStreakAPI.swift
//  HilingualNetwork
//
//  Created by youngseo on 8/23/26.
//

import Foundation
import Moya

public enum WidgetStreakAPI {
    case getStreak(date: String)
}

extension WidgetStreakAPI: BaseTargetType {
    public var path: String {
        switch self {
        case .getStreak:
            return "/v1/widget/streak"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .getStreak:
            return .get
        }
    }

    public var task: Moya.Task {
        switch self {
        case let .getStreak(date):
            return .requestParameters(
                parameters: ["date": date],
                encoding: URLEncoding.queryString
            )
        }
    }
}
