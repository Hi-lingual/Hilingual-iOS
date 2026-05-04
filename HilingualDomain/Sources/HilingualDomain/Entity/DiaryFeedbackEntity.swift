//
//  DiaryFeedbackEntity.swift
//  HilingualDomain
//
//  Created by 진소은 on 7/9/25.
//

import Foundation

public struct DiaryFeedbackEntity {
    public let original: String
    public let rewrite: String
    public let explain: String
    
    public init(original: String, rewrite: String, explain: String) {
        self.original = original
        self.rewrite = rewrite
        self.explain = explain
    }
}

