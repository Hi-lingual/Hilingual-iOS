//
//  DiaryControlAPI.swift
//  HilingualNetwork
//
//  Created by 진소은 on 9/5/25.
//

import Moya

public enum DiaryControlAPI {
    case deleteDiary(diaryId: Int)
    case publishDiary(diaryId: Int)
    case unpublishDiary(diaryId: Int)
}

extension DiaryControlAPI: BaseTargetType {
    public var path: String {
        switch self {
        case .deleteDiary(let diaryId):
            return "/diaries/\(diaryId)"
        case .publishDiary(let diaryId):
            return "/diaries/\(diaryId)/publish"
        case .unpublishDiary(let diaryId):
            return "/diaries/\(diaryId)/unpublish"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .deleteDiary:
            return .delete
        case .publishDiary:
            return .patch
        case .unpublishDiary:
            return .patch
        }
    }
    
    public var task: Task {
        switch self {
        case .deleteDiary(let diaryId):
            return .requestPlain
        case .publishDiary(let diaryId):
            return .requestPlain
            
        case .unpublishDiary(let diaryId):
            return .requestPlain
        }
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
}
