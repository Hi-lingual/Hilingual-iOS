//
//  DiaryInfoDTO+Mapper.swift
//  HilingualData
//
//  Created by 조영서 on 7/16/25.
//

import HilingualDomain
import HilingualNetwork

public enum DiaryInfoMapper {
    public static func map(from dto: DiaryInfoDTO.DiaryDataDTO) -> DiaryInfoEntity {
        return DiaryInfoEntity(
            diaryId: dto.diaryId,
            imageUrl: dto.imageUrl,
            originalText: dto.originalText
        )
    }
}
