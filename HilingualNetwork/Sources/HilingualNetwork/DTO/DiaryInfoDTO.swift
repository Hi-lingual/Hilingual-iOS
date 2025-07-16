//
//  DiaryInfoDTO.swift
//  HilingualNetwork
//
//  Created by 조영서 on 7/16/25.
//

public struct DiaryInfoDTO: Decodable {
    public let data: DiaryDataDTO?

    public struct DiaryDataDTO: Decodable {
        public let diaryId: Int
        public let imageUrl: String
        public let originalText: String
    }
}
