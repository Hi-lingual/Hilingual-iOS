//
//  DiaryDetailDTO.swift
//  HilingualNetwork
//
//  Created by 진소은 on 7/9/25.
//

import Foundation

public struct DiaryDetailResponseDTO: Decodable {
    public let code: Int
    public let data: CorrectionData?
    public let message: String
    
    public struct CorrectionData: Decodable {
        public let date: String
        public let originalText: String
        public let rewriteText: String
        public let diffRanges: [DiffRange]
        public let imageUrl: String?
        public let isPublished: Bool
    }
    
    public struct DiffRange: Decodable {
        public let start: Int
        public let end: Int
        public let correctedText: String
    }
}
