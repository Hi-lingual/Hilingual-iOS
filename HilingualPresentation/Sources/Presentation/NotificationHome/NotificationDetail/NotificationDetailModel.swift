//
//  NotificationDetailModel.swift
//  HilingualPresentation
//
//  Created by 성현주 on 8/26/25.
//

import Foundation

public struct NotificationDetailModel {
    public let title: String
    public let content: String

    private let rawDate: String

    public var date: String {
        return rawDate.replacingOccurrences(of: "-", with: ".")
    }

    public init(title: String, date: String, content: String) {
        self.title = title
        self.rawDate = date
        self.content = content
    }
}
