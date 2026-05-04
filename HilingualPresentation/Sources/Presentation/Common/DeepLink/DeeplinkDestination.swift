//
//  DeeplinkDestination.swift
//  HilingualPresentation
//
//  Created by 성현주 on 8/26/25.
//

import Foundation

public enum DeeplinkDestination {
    case diaryDetail(diaryId: Int)
    case userProfile(userId: Int)
    case home
}
