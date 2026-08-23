//
//  WidgetTopicEntity.swift
//  HilingualDomain
//
//  Created by youngseo on 8/23/26.
//

import Foundation

public struct WidgetTopicEntity {
    public let topicEn: String?
    public let isWrittenToday: Bool?

    public init(topicEn: String?, isWrittenToday: Bool?) {
        self.topicEn = topicEn
        self.isWrittenToday = isWrittenToday
    }
}
