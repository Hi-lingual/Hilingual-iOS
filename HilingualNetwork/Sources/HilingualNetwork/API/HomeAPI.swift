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
    case getDiaryInfo(date: String)
    case getTopic(date: String)
}

extension HomeAPI: BaseTargetType {

    public var path: String {
        switch self {
        case .getUserInfo:
            return "/users/info"
        case .getMonthInfo:
            return "/calendar/month"
        case let .getDiaryInfo(date):
            return "/calendar/\(date)"
        case let .getTopic(date):
            return "/calendar/\(date)/topic"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .getUserInfo,
             .getMonthInfo,
             .getDiaryInfo,
             .getTopic:
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
        case .getDiaryInfo, .getTopic:
            return .requestPlain
        }
    }
}
