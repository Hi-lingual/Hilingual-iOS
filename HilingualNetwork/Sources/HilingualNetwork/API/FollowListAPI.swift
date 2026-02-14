//
//  FollowListAPI.swift
//  HilingualNetwork
//
//  Created by 신혜연 on 9/9/25.
//

import Foundation
import Moya

public enum FollowListAPI {
    case fetchFollowers(targetUserId: Int)
    case fetchFollowings(targetUserId: Int)
}

extension FollowListAPI: BaseTargetType {
    public var path: String {
        switch self {
        case .fetchFollowers(let targetUserId):
            return "/users/following/\(targetUserId)/followers"
        case .fetchFollowings(let targetUserId):
            return "/users/following/\(targetUserId)/followings"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .fetchFollowers, .fetchFollowings:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .fetchFollowers, .fetchFollowings:
            return .requestPlain
        }
    }
}
