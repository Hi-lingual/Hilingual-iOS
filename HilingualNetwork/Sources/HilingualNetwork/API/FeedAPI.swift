//
//  FeedAPI.swift
//  HilingualNetwork
//
//  Created by 조영서 on 8/20/25.
//

import Foundation
import Moya

public enum FeedAPI {
    case fetchRecommendedFeed
    case fetchFollowingFeed
}

extension FeedAPI: BaseTargetType {
    public var path: String {
        switch self {
        case .fetchRecommendedFeed: return "/feed/recommended"
        case .fetchFollowingFeed:   return "/feed/following"
        }
    }
    public var method: Moya.Method { .get }
    public var task: Task { .requestPlain }
}
