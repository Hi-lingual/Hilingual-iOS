//
//  LoginOnBoardingPageModel.swift
//  HilingualPresentation
//
//  Created by 성현주 on 2/12/26.
//

import Foundation

struct LoginOnBoardingModel {
    let text: String
    let highlightText: String?
    let imageName: String
}

extension LoginOnBoardingModel {
    static let pages: [LoginOnBoardingModel] = [
        .init(
            text: "48시간 동안 작성하는\n꾸준한 영어일기",
            highlightText: "48시간",
            imageName: "img_onboarding_1_ios"
        ),
        .init(
            text: "한 줄도, 한국어도, 사진도\n괜찮은 일기 작성",
            highlightText: "일기 작성",
            imageName: "img_onboarding_2_ios"
        ),
        .init(
            text: "영어일기에 최적화 된\n간편한 AI 피드백",
            highlightText: "AI 피드백",
            imageName: "img_onboarding_3_ios"
        ),
        .init(
            text: "일기를 공유하며\n더불어 성장하는 피드",
            highlightText: "일기를 공유",
            imageName: "img_onboarding_4_ios"
        )
    ]
}
