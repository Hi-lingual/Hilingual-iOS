//
//  FeedbackData.swift
//  HilingualPresentation
//
//  Created by 진소은 on 7/14/25.
//


//
//  FeedbackData.swift
//  HilingualPresentation
//
//  Created by 진소은 on 7/13/25.
//

struct FeedbackData: Codable {
    let code: Int
    let data: [DataContent]
    let message: String
    
    struct DataContent: Codable {
        let originalText: String
        let rewriteText: String
        let explanation: String
    }
}

let dummyFeedbackData =  FeedbackData(
    code: 200,
    data: [
        FeedbackData.DataContent(
            originalText: "I was planning to arrive it here around 13:30",
            rewriteText: "I was planning to arrive here around 1:30 p.m",
            explanation: "arrive는 자동사이기 때문에 직접 목적어 ‘it’을 쓸 수 없어요. ‘arrive at the station’, ‘arrive here’처럼 써야 맞는 표현이에요!"
        ),
        FeedbackData.DataContent(
            originalText: "I was planning to arrive it here around 13:30",
            rewriteText: "I was planning to arrive here around 1:30 p.m",
            explanation: "arrive는 자동사이기 때문에 직접 목적어 ‘it’을 쓸 수 없어요. ‘arrive at the station’, ‘arrive here’처럼 써야 맞는 표현이에요!"
        )
    ],
    message: "ok"
)
