//
//  FeedProfileDiaryItem.swift
//  HilingualPresentation
//
//  Created by 조영서 on 8/24/25.
//

import Foundation

struct FeedProfileDiaryItem {
    let id: Int
    let nickname: String
    let profileImg: String
    let isMine: Bool
    let streak: Int?
    let sharedDateMinutes: Int
    let diaryPreviewText: String
    let diaryImageUrl: String?
    let isLiked: Bool
    let likeCount: Int
}
