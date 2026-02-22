//
//  Character+.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 7/17/25.
//

import Foundation

extension Character {
    var isEmoji: Bool {
        return unicodeScalars.contains { $0.properties.isEmoji && ($0.value > 0x238C || $0.value == 0x00A9 || $0.value == 0x00AE) }
    }
}
