//
//  HomeAPI.swift
//  Hilingual
//
//  Created by 조영서 on 7/16/25.
//

import Foundation
import Moya

public enum HomeAPI {
    case getUserInfo
    case getMonthInfo(year: Int, month: Int)
}

extension HomeAPI: BaseTargetType {

    public var path: String {
        switch self {
        case .getUserInfo:
            return "/users/info"
        case .getMonthInfo:
            return "/calendar/month"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .getUserInfo, .getMonthInfo:
            return .get
        }
    }

    public var task: Task {
        switch self {
        case .getUserInfo:
            return .requestPlain
        case let .getMonthInfo(year, month):
            return .requestParameters(
                parameters: ["year": year, "month": month],
                encoding: OrderedURLEncoding()
            )
        }
    }
}
