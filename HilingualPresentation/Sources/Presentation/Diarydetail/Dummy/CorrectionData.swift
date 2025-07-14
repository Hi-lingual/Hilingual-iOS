//
//  CorrectionData.swift
//  HilingualPresentation
//
//  Created by 진소은 on 7/11/25.
//


struct CorrectionData: Codable {
    let code: Int
    let data: DataContent
    let message: String

    struct DataContent: Codable {
        let date: String
        let image: String?
        let originalText: String
        let rewriteText: String
        let diffRanges: [DiffRange]
    }

    struct DiffRange: Codable {
        let start: Int
        let end: Int
        let originalText: String
        let correctedText: String
    }
}

let dummyCorrectionData = CorrectionData(
    code: 200,
    data: CorrectionData.DataContent(
        date: "8월 21일 목요일",
        image: "https://hilingual-bucket.s3.ap-northeast-2.amazonaws.com/diary/sample-image.png",
        originalText: "Today I went to the cafe Conhas in Yeonnam to meet my teammates. I was planning to arrive around 1:30 p.m., but I got there at 2:20 because I overslept, as always. I wore rain boots and brought my favorite umbrella because the weather forecast said it would rain all day, but it wasn’t really raining much outside. I got kind of disappointed. But yes, no rain is better than rain, I guess.After arriving, I had a jambon arugula sandwich with a vanilla latte. Honestly, I should be more careful when I'm drinking milk because I get stomachaches easily, but I always order lattes.My life feels like a disaster, a mess that I call myself. But they tasted really good, so I felt more motivated to work. I really liked this café because it's spacious, chill, and has a great atmosphere for focusing. I’ll definitely come back again soon!",
        rewriteText: "REWRITE /// Today I went to the cafe Conhas in Yeonnam to meet my teammates. I was planning to arrive around 1:30 p.m., but I got there at 2:20 because I overslept, as always. I wore rain boots and brought my favorite umbrella because the weather forecast said it would rain all day, but it wasn’t really raining much outside. I got kind of disappointed. But yes, no rain is better than rain, I guess.After arriving, I had a jambon arugula sandwich with a vanilla latte. Honestly, I should be more careful when I'm drinking milk because I get stomachaches easily, but I always order lattes.My life feels like a disaster, a mess that I call myself. But they tasted really good, so I felt more motivated to work. I really liked this café because it's spacious, chill, and has a great atmosphere for focusing. I’ll definitely come back again soon!",
        diffRanges: [
            .init(
                start: 0, end: 7, originalText: "asdf", correctedText: "asfd"
            ),
            .init(
                start: 79,
                end: 140,
                originalText: "arrive around 1:30 p.m., but I got there at 2:20",
                correctedText: "arrive at 1:30 p.m., but I ended up getting there at 2:20"
            ),
            .init(
                start: 200,
                end: 240,
                originalText: "it wasn’t really raining much outside.",
                correctedText: "it hardly rained outside at all."
            ),
            .init(
                start: 380,
                end: 450,
                originalText: "I get stomachaches easily, but I always order lattes.",
                correctedText: "I’m lactose intolerant, but I still end up ordering lattes."
            )
        ]
    ),
    message: "AI가 교정한 내용과 index를 반환했습니다."
)
