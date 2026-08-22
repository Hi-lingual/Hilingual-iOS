//
//  WidgetTopicAPI.swift
//  HilingualNetwork
//
//  Created by youngseo on 8/23/26.
//

import Foundation
import Moya

public enum WidgetTopicAPI {
    case getTopic(date: String)
}

extension WidgetTopicAPI: BaseTargetType {
    public var path: String {
        switch self {
        case .getTopic:
            return "/v1/widget/topic"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .getTopic:
            return .get
        }
    }

    public var task: Moya.Task {
        switch self {
        case let .getTopic(date):
            return .requestParameters(
                parameters: ["date": date],
                encoding: URLEncoding.queryString
            )
        }
    }
}
