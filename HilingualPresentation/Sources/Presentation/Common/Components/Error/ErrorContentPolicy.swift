//
//  ErrorContentPolicy.swift
//  HilingualPresentation
//
//  Created by 성현주 on 6/27/26.
//

// 에러 정책의 단일 출처(Single Source of Truth).
// "어떤 에러를, 어떤 표현 형태로, 어떤 문구/이미지/버튼으로 보여줄지"가 모두 이 파일에 모인다.
// 정책을 바꾸려면 이 파일만 수정하면 전 화면에 반영된다.

import UIKit
import HilingualCore

/// 에러를 보여주는 표현 형태. 화면(호출부)이 상황에 맞게 선택한다.
/// - `fullPage`: 화면 전체 데이터를 불러오지 못한 경우 (탭O/탭X는 네비 스택에 의해 자동)
/// - `fullPageFeedback`: AI 피드백 생성 실패 전용 풀페이지
/// - `modal`: 기존 화면 콘텐츠를 유지해야 하는 부분 실패 (저장 실패, 단어장 데이터 없음 등)
/// - `toast`: 네트워크 끊김을 화면 이동 전에 감지한 경우 등 가벼운 안내
enum ErrorDisplayForm {
    case fullPage
    case fullPageFeedback
    case modal
    case toast
}

/// 풀페이지 에러 버튼이 수행할 동작.
enum ErrorButtonRole {
    case retry
    case goBack
}

/// 풀페이지 에러 1건의 표현 명세(그릴 내용 + 버튼 동작).
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
