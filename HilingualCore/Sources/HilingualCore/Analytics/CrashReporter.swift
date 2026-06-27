//
//  CrashReporter.swift
//  HilingualCore
//
//  Created by 성현주 on 6/27/26.
//

// 크래시/비치명(non-fatal) 에러 리포팅 추상화.
// 구현(Crashlytics 등)은 앱 타겟에서 주입한다. Core/Network/Presentation 은 Firebase에 의존하지 않는다.

import Foundation

public protocol CrashReporting: AnyObject {
    func record(_ error: Error, userInfo: [String: String])
    func log(_ message: String)
}

public enum CrashReporter {

    nonisolated(unsafe) public static var reporter: CrashReporting?

    public static func record(_ error: Error, userInfo: [String: String] = [:]) {
        reporter?.record(error, userInfo: userInfo)
    }

    public static func log(_ message: String) {
        reporter?.log(message)
    }
}
