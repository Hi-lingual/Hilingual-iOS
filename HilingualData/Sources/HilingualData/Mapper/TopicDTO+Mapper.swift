//
//  TopicDTO+Mapper.swift
//  HilingualData
//
//  Created by 조영서 on 7/16/25.
//

import HilingualDomain
import HilingualNetwork

public enum TopicMapper {
    public static func map(from dto: TopicDTO.TopicDataDTO) -> TopicEntity {
        return TopicEntity(
            topicKor: dto.topicKor,
            topicEn: dto.topicEn,
            remainingTime: dto.remainingTime
        )
    }
}
