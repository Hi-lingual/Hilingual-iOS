//
//  FeedSearchAPI.swift
//  HilingualNetwork
//
//  Created by 신혜연 on 9/8/25.
//

import Foundation
import Moya

public enum FeedSearchAPI {
    case searchUsers(keyword: String)
}

extension FeedSearchAPI: BaseTargetType {
    public var path: String {
        switch self {
        case .searchUsers:
            return "/feed/search"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .searchUsers:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .searchUsers(let keyword):
            return .requestParameters(parameters: ["keyword": keyword], encoding: URLEncoding.queryString)
        }
    }
}
