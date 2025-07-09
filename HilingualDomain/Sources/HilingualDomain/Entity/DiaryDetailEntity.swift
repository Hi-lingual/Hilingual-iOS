//
//  DiaryDetailEntity.swift
//  HilingualDomain
//
//  Created by 진소은 on 7/9/25.
//

import Foundation

public struct DiaryDetailEntity {
    let code: Int
    let data: CorrectionData?
    let message: String
    
    struct CorrectionData {
        let date: String
        let image: String
        let originalFullText: String
        let rewritedFullText: String
        let diffRanges: DiffRange
    }
    
    struct DiffRange {
        let start: Int
        let end: Int
        let originalText: String
        let correctedText: String
    }
}
