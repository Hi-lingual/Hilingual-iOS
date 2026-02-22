//
//  TopicEntity.swift
//  HilingualDomain
//
//  Created by 조영서 on 7/16/25.
//

public struct TopicEntity {
    public let topicKor: String
    public let topicEn: String
    public let remainingTime: Int

    public init(topicKor: String, topicEn: String, remainingTime: Int) {
        self.topicKor = topicKor
        self.topicEn = topicEn
        self.remainingTime = remainingTime
    }
}
