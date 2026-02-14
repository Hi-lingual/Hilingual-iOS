//
//  FeedDiaryItem.swift
//  HilingualPresentation
//
//  Created by 조영서 on 8/21/25.
//

import Foundation

public struct FeedModel {
    let diaryID: Int
    let userID: Int 
    let nickname: String
    let profileImg: String?
    let isMine: Bool
    let streak: Int?
    let sharedDateMinutes: Int
    let diaryPreviewText: String?
    let diaryImageUrl: String?
    let isLiked: Bool
    let likeCount: Int
}
