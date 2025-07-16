//
//  RecommendedVocaAPI.swift
//  HilingualNetwork
//
//  Created by 진소은 on 7/16/25.
//

import Foundation
import Moya

public enum RecommendedVocaAPI {
    case fetchRecommendedVoca(diaryId: Int)
}

extension RecommendedVocaAPI: BaseTargetType {
    public var path: String {
        switch self {
        case .fetchRecommendedVoca(let diaryId):
            return "diaries/\(diaryId)/recommended"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var task: Task {
        switch self {
        case .fetchRecommendedVoca:
            return .requestPlain
        }
    }
}
