//
//  HilingualLog.swift
//  Hilingual
//
//  Created by 성현주 on 7/3/25.
//

import Foundation

public final class HilingualLog {
    public static func debug(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        let output = items.map { "\($0)" }.joined(separator: separator)
        print("🗣 [\(getCurrentTime())] \(output)", terminator: terminator)
    }

    public static func warning(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        let output = items.map { "\($0)" }.joined(separator: separator)
        print("⚡️ [\(getCurrentTime())] \(output)", terminator: terminator)
    }

    public static func error(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        let output = items.map { "\($0)" }.joined(separator: separator)
        print("🚨 [\(getCurrentTime())] \(output)", terminator: terminator)
    }

    fileprivate static func getCurrentTime() -> String {
        let now = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        return dateFormatter.string(from: now as Date)
    }
}
