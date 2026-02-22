//
//  DiaryDetailEntity.swift
//  HilingualDomain
//
//  Created by 진소은 on 7/9/25.
//

import Foundation

public struct DiaryDetailEntity {
    public let date: String
    public let image: String?
    public let originalText: String
    public let rewriteText: String
    public let diffRanges: [DiffRange]
    public let isPublished: Bool
    
    public struct DiffRange {
        public let start: Int
        public let end: Int
        public let correctedText: String
        
        public init(start: Int, end: Int, correctedText: String) {
            self.start = start
            self.end = end
            self.correctedText = correctedText
        }
    }
    
    public init(date: String, image: String, originalText: String, rewriteText: String, diffRanges: [DiffRange], isPublished: Bool) {
        self.date = date
        self.image = image
        self.originalText = originalText
        self.rewriteText = rewriteText
        self.diffRanges = diffRanges
        self.isPublished = isPublished
    }
    
    
}
