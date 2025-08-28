//
//  FeedProfileListType.swift
//  HilingualPresentation
//
//  Created by 조영서 on 8/26/25.
//

import Foundation

public enum FeedProfileListType {
    case liked
    case shared

    public var emptyMessage: String {
        switch self {
        case .liked:  return "아직 공감한 일기가 없어요."
        case .shared: return "아직 공유한 일기가 없어요."
        }
    }
}
