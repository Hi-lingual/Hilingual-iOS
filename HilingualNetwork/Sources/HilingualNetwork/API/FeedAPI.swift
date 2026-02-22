//
//  FeedAPI.swift
//  HilingualNetwork
//
//  Created by 조영서 on 8/20/25.
//

import Foundation
import Moya

public enum FeedAPI {
    case fetchRecommendFeed
    case fetchFollowingFeed
}

extension FeedAPI: BaseTargetType {
    public var path: String {
        switch self {
        case .fetchRecommendFeed: return "/feed/recommend"
        case .fetchFollowingFeed:   return "/feed/following"
        }
    }
    public var method: Moya.Method { .get }
    public var task: Task { .requestPlain }
}
