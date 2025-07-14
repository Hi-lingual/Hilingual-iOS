//
//  PhraseData.swift
//  HilingualPresentation
//
//  Created by 진소은 on 7/14/25.
//

struct PhraseData: Codable {
    let code: Int
    let data: DataContent
    let message: String

    struct DataContent: Codable {
        let phraseList: [PhraseList]
    }

    struct PhraseList: Codable {
        let phraseId: Int
        let phraseType: [String]
        let phrase: String
        let explanation: String
        let reason: String
        let createdAt: String
        let isMarked: Bool
    }
}

let dummyPhraseData = PhraseData(
    code: 200,
    data: PhraseData.DataContent(
        phraseList: [
            PhraseData.PhraseList(
                phraseId: 111,
                phraseType: ["동사", "명사"],
                phrase: "resonate with",
                explanation: "~와 깊이 공감되다, 마음에 와닿다",
                reason: "“Their lyrics really resonate with me.”처럼 사용하면 감정적인 연결을 강조할 수 있어요.",
                createdAt: "25.07.14",
                isMarked: false
            ),
            PhraseData.PhraseList(
                phraseId: 111,
                phraseType: ["동사", "명사"],
                phrase: "resonate with",
                explanation: "~와 깊이 공감되다, 마음에 와닿다",
                reason: "“Their lyrics really resonate with me.”처럼 사용하면 감정적인 연결을 강조할 수 있어요.",
                createdAt: "25.07.14",
                isMarked: false
            ),
            PhraseData.PhraseList(
                phraseId: 111,
                phraseType: ["동사", "명사"],
                phrase: "resonate with",
                explanation: "~와 깊이 공감되다, 마음에 와닿다",
                reason: "“Their lyrics really resonate with me.”처럼 사용하면 감정적인 연결을 강조할 수 있어요.",
                createdAt: "25.07.14",
                isMarked: false
            ),
            PhraseData.PhraseList(
                phraseId: 111,
                phraseType: ["동사", "명사"],
                phrase: "resonate with",
                explanation: "~와 깊이 공감되다, 마음에 와닿다",
                reason: "“Their lyrics really resonate with me.”처럼 사용하면 감정적인 연결을 강조할 수 있어요.",
                createdAt: "25.07.14",
                isMarked: false
            ),
            PhraseData.PhraseList(
                phraseId: 111,
                phraseType: ["동사", "명사"],
                phrase: "resonate with",
                explanation: "~와 깊이 공감되다, 마음에 와닿다",
                reason: "“Their lyrics really resonate with me.”처럼 사용하면 감정적인 연결을 강조할 수 있어요.",
                createdAt: "25.07.14",
                isMarked: false
            )
        ]
    ),
    message: "추천표현 목록을 성공적으로 불러왔습니다."
)
