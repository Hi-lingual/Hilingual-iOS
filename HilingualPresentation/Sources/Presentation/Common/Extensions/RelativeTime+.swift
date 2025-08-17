//
//  RelativeTime+.swift
//  HilingualPresentation
//
//  Created by 조영서 on 8/17/25.
//

import Foundation

extension Int {
    var asRelativeTimeTextKR: String {
        //음수 방지
        let minutes = Swift.max(0, self)

        if minutes < 1 { return "방금 전" }
        if minutes < 60 { return "\(minutes)분 전" }
        if minutes <= 24 * 60 { return "\(minutes / 60)시간 전" }
        if minutes <= 7 * 24 * 60 { return "\(minutes / (24 * 60))일 전" }

        let date = Date().addingTimeInterval(TimeInterval(-minutes * 60))
        return date.toFormattedString("M월 d일")
    }
}
