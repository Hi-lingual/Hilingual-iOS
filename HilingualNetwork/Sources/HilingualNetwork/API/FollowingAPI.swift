//
//  FollowingAPI.swift
//  HilingualNetwork
//
//  Created by 신혜연 on 9/9/25.
//

import Foundation
import Moya

public enum FollowingAPI {
    case follow(targetUserId: Int64)
    case unfollow(targetUserId: Int64)
}

extension FollowingAPI: BaseTargetType {
    public var path: String {
        switch self {
        case .follow(let targetUserId), .unfollow(let targetUserId):
            return "/users/following/\(targetUserId)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .follow:
            return .put
        case .unfollow:
            return .delete
        }
    }
    
    public var task: Task {
        return .requestPlain
    }
}
