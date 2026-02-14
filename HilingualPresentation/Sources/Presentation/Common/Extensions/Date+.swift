//
//  Date+.swift
//  HilingualPresentation
//
//  Created by 조영서 on 7/16/25.
//

import Foundation

extension Date {
    func toFormattedString(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: self)
    }
}
