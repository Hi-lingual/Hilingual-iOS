//
//  DiaryDetailAPI.swift
//  HilingualNetwork
//
//  Created by 진소은 on 7/16/25.
//

import Foundation
import Moya

public enum DiaryDetailAPI {
    case fetchDiaryDetail(diaryId: Int)
}

extension DiaryDetailAPI: BaseTargetType {
    public var path: String {
        switch self {
        case .fetchDiaryDetail(let diaryId):
            return "diaries/\(diaryId)"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var task: Task {
        switch self {
        case .fetchDiaryDetail:
            return .requestPlain
        }
    }
}
