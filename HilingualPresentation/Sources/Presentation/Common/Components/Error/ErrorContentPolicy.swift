//
//  ErrorContentPolicy.swift
//  HilingualPresentation
//
//  Created by 성현주 on 6/27/26.
//

import UIKit
import HilingualCore

enum ErrorDisplayForm {
    case fullPage
    case fullPageFeedback
    case modal
    case toast
}

enum ErrorButtonRole {
    case retry
    case goBack
}

struct FullPageErrorSpec {
    let content: FullPageErrorView.Content
    let role: ErrorButtonRole
}

enum ErrorContentPolicy {

    // MARK: - Full Page

    static func fullPage(for error: HilingualError) -> FullPageErrorSpec {
        switch error {
        case .dataNotFound:
            return FullPageErrorSpec(
                content: .init(
                    image: UIImage(resource: .imgErrorIos),
                    title: "정보를 불러오지 못했어요.",
                    subtitle: "이전 화면으로 돌아가 다시 확인 해주세요.",
                    buttonTitle: "이전 페이지로 돌아가기",
                    placement: .belowText,
                    fullWidthButton: false
                ),
                role: .goBack
            )

        case .network:
            return FullPageErrorSpec(
                content: .init(
                    image: UIImage(resource: .imgNetworkErrorIos),
                    title: "인터넷 연결이 불안정해요.",
                    subtitle: "연결 상태를 확인한 뒤 다시 시도해주세요.",
                    buttonTitle: "다시 시도",
                    placement: .belowText,
                    fullWidthButton: false
                ),
                role: .retry
            )

        case .server, .unauthorized:
            return FullPageErrorSpec(
                content: .init(
                    image: UIImage(resource: .imgErrorIos),
                    title: "일시적인 오류가 발생해\n내용을 불러오지 못했어요.",
                    subtitle: nil,
                    buttonTitle: "다시 시도",
                    placement: .belowText,
                    fullWidthButton: false
                ),
                role: .retry
            )
        }
    }

    static func feedbackFullPage() -> FullPageErrorSpec {
        FullPageErrorSpec(
            content: .init(
                image: UIImage(resource: .imgErrorDiaryIos),
                title: "피드백을 받는 중에\n일시적인 오류가 발생했어요!",
                subtitle: "잠시 후 다시 시도해주세요.",
                buttonTitle: "피드백 다시 요청하기",
                placement: .bottom,
                fullWidthButton: true
            ),
            role: .retry
        )
    }

    // MARK: - Modal / Toast

    static func modalTitle(for error: HilingualError) -> String {
        "앗! 일시적인 오류가 발생했어요."
    }

    static func toastMessage(for error: HilingualError) -> String {
        switch error {
        case .network:
            return "인터넷 연결이 불안정해요."
        default:
            return "앗! 일시적인 오류가 발생했어요."
        }
    }
}
