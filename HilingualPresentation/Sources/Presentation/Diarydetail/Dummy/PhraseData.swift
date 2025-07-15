//
//  PhraseData.swift
//  HilingualPresentation
//
//  Created by 진소은 on 7/14/25.
//

struct PhraseData: Codable {
    let phraseId: Int64
    let phraseType: [String]
    let phrase: String
    let explanation: String
    let reason: String
    let createdAt: String
    var isMarked: Bool
}


let dummyPhraseData : [PhraseData] = [
    PhraseData(
        phraseId: 111,
        phraseType: ["동사", "명사"],
        phrase: "resonate with",
        explanation: "~와 깊이 공감되다, 마음에 와닿다",
        reason: "“Their lyrics really resonate with me.”처럼 사용하면 감정적인 연결을 강조할 수 있어요.",
        createdAt: "25.07.14",
        isMarked: true
    ),
    PhraseData(
        phraseId: 111,
        phraseType: ["동사", "명사"],
        phrase: "resonate with",
        explanation: "~와 깊이 공감되다, 마음에 와닿다",
        reason: "“Their lyrics really resonate with me.”처럼 사용하면 감정적인 연결을 강조할 수 있어요.",
        createdAt: "25.07.14",
        isMarked: false
    ),
    PhraseData(
        phraseId: 111,
        phraseType: ["동사", "명사"],
        phrase: "resonate with",
        explanation: "~와 깊이 공감되다, 마음에 와닿다",
        reason: "“Their lyrics really resonate with me.”처럼 사용하면 감정적인 연결을 강조할 수 있어요.",
        createdAt: "25.07.14",
        isMarked: true
    ),
    PhraseData(
        phraseId: 111,
        phraseType: ["동사", "명사"],
        phrase: "resonate with",
        explanation: "~와 깊이 공감되다, 마음에 와닿다",
        reason: "“Their lyrics really resonate with me.”처럼 사용하면 감정적인 연결을 강조할 수 있어요.",
        createdAt: "25.07.14",
        isMarked: false
    ),
    PhraseData(
        phraseId: 111,
        phraseType: ["동사", "명사"],
        phrase: "resonate with",
        explanation: "~와 깊이 공감되다, 마음에 와닿다",
        reason: "“Their lyrics really resonate with me.”처럼 사용하면 감정적인 연결을 강조할 수 있어요.",
        createdAt: "25.07.14",
        isMarked: false
    )
]
