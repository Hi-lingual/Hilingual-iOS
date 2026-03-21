//
//  Date+.swift
//  HilingualPresentation
//
//  Created by 조영서 on 7/16/25.
//

import Foundation
import HilingualCore

extension Date {
    func toFormattedString(_ format: String) -> String {
        let formatter = AppTimeZone.formatter(format)
        return formatter.string(from: self)
    }
}
