//
//  TopicDTO.swift
//  HilingualNetwork
//
//  Created by 조영서 on 7/16/25.
//

public struct TopicDTO: Decodable {
    public let data: TopicDataDTO?

    public struct TopicDataDTO: Decodable {
        public let topicKor: String
        public let topicEn: String
        public let remainingTime: Int
    }
}
