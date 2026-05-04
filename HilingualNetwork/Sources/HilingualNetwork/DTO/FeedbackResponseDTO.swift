//
//  FeedbackResponseDTO.swift
//  HilingualNetwork
//
//  Created by 진소은 on 7/15/25.
//

import Foundation

public struct FeedbackResponseDTO: Decodable {
    public let code: Int
    public let message: String
    public let data: FeedbackData
    
    public struct FeedbackData: Decodable {
        public let feedbackList: [FeedbackItem]
    }
    
    public struct FeedbackItem: Decodable {
        public let original: String
        public let rewrite: String
        public let explain: String
    }
}
