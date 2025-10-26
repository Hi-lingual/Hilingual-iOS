//
//  File.swift
//  HilingualPresentation
//
//  Created by 성현주 on 10/26/25.
//

import Foundation

/// Amplitude 이벤트 로깅을 위한 편의 메서드 모음
/// 네이밍 룰: event는 'page.action' 형식, attributes는 snake_case
@MainActor
public extension AmplitudeManager {

    // MARK: - Screen Events

    /// 화면 조회 이벤트
    /// - Parameter screenName: 화면 이름
    func logScreenView(_ screenName: String) {
        logEvent("screen.pageview", properties: ["screen_name": screenName])
    }

    // MARK: - Common Interaction Events

    /// 버튼 탭 이벤트
    /// - Parameters:
    ///   - buttonName: 버튼 이름
    ///   - screenName: 화면 이름
    func logButtonTap(buttonName: String, screenName: String) {
        logEvent("button.tap", properties: [
            "button_name": buttonName,
            "screen_name": screenName
        ])
    }

    /// 검색 이벤트
    /// - Parameters:
    ///   - query: 검색어
    ///   - resultCount: 결과 개수
    func logSearch(query: String, resultCount: Int) {
        logEvent("search.submit", properties: [
            "query": query,
            "result_count": resultCount
        ])
    }

    /// 에러 이벤트
    /// - Parameters:
    ///   - errorType: 에러 타입
    ///   - errorMessage: 에러 메시지
    ///   - screenName: 화면 이름
    func logError(errorType: String, errorMessage: String, screenName: String) {
        logEvent("error.occurred", properties: [
            "error_type": errorType,
            "error_message": errorMessage,
            "screen_name": screenName
        ])
    }
}

// MARK: -  일기 작성
@MainActor
public extension AmplitudeManager {

    /// 일기 작성 시작
    func logDiaryWriteStart() {
        logEvent("diary_write.start", properties: [:])
    }

    /// 일기 작성 진행 중
    /// - Parameter wordCount: 현재 단어 수
    func logDiaryWriteInProgress(wordCount: Int) {
        logEvent("diary_write.in_progress", properties: [
            "word_count": wordCount
        ])
    }

    /// 일기 작성 완료
    /// - Parameters:
    ///   - diaryId: 일기 ID
    ///   - wordCount: 최종 단어 수
    ///   - timeSpent: 작성 소요 시간 (초)
    func logDiaryWriteComplete(diaryId: String, wordCount: Int, timeSpent: TimeInterval) {
        logEvent("diary_write.complete", properties: [
            "diary_id": diaryId,
            "word_count": wordCount,
            "time_spent_seconds": Int(timeSpent)
        ])
    }

    /// 일기 작성 취소
    /// - Parameter wordCount: 취소 시점의 단어 수
    func logDiaryWriteCancel(wordCount: Int) {
        logEvent("diary_write.cancel", properties: [
            "word_count": wordCount
        ])
    }
}

// MARK: -  피드백 상세
@MainActor
public extension AmplitudeManager {

    /// 피드백 상세 페이지 진입
    /// - Parameters:
    ///   - diaryId: 일기 ID
    ///   - feedbackType: 피드백 타입 (grammar, spelling, expression 등)
    func logFeedbackDetailView(diaryId: String, feedbackType: String) {
        logEvent("feedback_detail.pageview", properties: [
            "diary_id": diaryId,
            "feedback_type": feedbackType
        ])
    }

    /// 피드백 항목 클릭
    /// - Parameters:
    ///   - diaryId: 일기 ID
    ///   - itemType: 항목 타입 (grammar, spelling, vocabulary 등)
    ///   - itemIndex: 항목 인덱스
    func logFeedbackItemTap(diaryId: String, itemType: String, itemIndex: Int) {
        logEvent("feedback_detail.item_tap", properties: [
            "diary_id": diaryId,
            "item_type": itemType,
            "item_index": itemIndex
        ])
    }

    /// 피드백 수정 적용
    /// - Parameters:
    ///   - diaryId: 일기 ID
    ///   - correctionCount: 적용한 수정 개수
    func logFeedbackApply(diaryId: String, correctionCount: Int) {
        logEvent("feedback_detail.apply", properties: [
            "diary_id": diaryId,
            "correction_count": correctionCount
        ])
    }
}

// MARK: - 🎯 핵심 퍼널: 피드 (일기 게시)
@MainActor
public extension AmplitudeManager {

    /// 피드 페이지 조회
    /// - Parameter section: 피드 섹션 (all, following, popular 등)
    func logFeedView(section: String = "all") {
        logEvent("feed.pageview", properties: [
            "section": section
        ])
    }

    /// 일기 게시 버튼 클릭
    /// - Parameter diaryId: 일기 ID
    func logDiaryPublishStart(diaryId: String) {
        logEvent("diary_publish.start", properties: [
            "diary_id": diaryId
        ])
    }

    /// 일기 게시 완료
    /// - Parameters:
    ///   - diaryId: 일기 ID
    ///   - isPublic: 공개 여부
    func logDiaryPublishComplete(diaryId: String, isPublic: Bool) {
        logEvent("diary_publish.complete", properties: [
            "diary_id": diaryId,
            "is_public": isPublic
        ])
    }

    /// 일기 게시 취소
    /// - Parameter diaryId: 일기 ID
    func logDiaryPublishCancel(diaryId: String) {
        logEvent("diary_publish.cancel", properties: [
            "diary_id": diaryId
        ])
    }

    /// 피드 아이템 클릭
    /// - Parameters:
    ///   - diaryId: 일기 ID
    ///   - authorId: 작성자 ID
    ///   - itemIndex: 아이템 위치
    func logFeedItemTap(diaryId: String, authorId: String, itemIndex: Int) {
        logEvent("feed.item_tap", properties: [
            "diary_id": diaryId,
            "author_id": authorId,
            "item_index": itemIndex
        ])
    }

    /// 좋아요
    /// - Parameters:
    ///   - diaryId: 일기 ID
    ///   - authorId: 작성자 ID
    func logFeedItemLike(diaryId: String, authorId: String) {
        logEvent("feed.like", properties: [
            "diary_id": diaryId,
            "author_id": authorId
        ])
    }

    /// 댓글 작성
    /// - Parameters:
    ///   - diaryId: 일기 ID
    ///   - commentLength: 댓글 길이
    func logFeedCommentSubmit(diaryId: String, commentLength: Int) {
        logEvent("feed.comment_submit", properties: [
            "diary_id": diaryId,
            "comment_length": commentLength
        ])
    }
}

// MARK: - Auth Events (인증 관련)
@MainActor
public extension AmplitudeManager {

    /// 로그인 시작
    /// - Parameter method: 로그인 방법 (email, google, apple 등)
    func logLoginStart(method: String) {
        logEvent("auth.login_start", properties: [
            "method": method
        ])
    }

    /// 로그인 완료
    /// - Parameter method: 로그인 방법
    func logLoginComplete(method: String) {
        logEvent("auth.login_complete", properties: [
            "method": method
        ])
    }

    /// 회원가입 완료
    /// - Parameter method: 가입 방법
    func logSignupComplete(method: String) {
        logEvent("auth.signup_complete", properties: [
            "method": method
        ])
    }

    /// 로그아웃
    func logLogout() {
        logEvent("auth.logout", properties: [:])
    }
}

// MARK: - Onboarding Events (온보딩)
@MainActor
public extension AmplitudeManager {

    /// 온보딩 시작
    func logOnboardingStart() {
        logEvent("onboarding.start", properties: [:])
    }

    /// 온보딩 단계 진행
    /// - Parameters:
    ///   - step: 현재 단계
    ///   - stepName: 단계 이름
    func logOnboardingStepView(step: Int, stepName: String) {
        logEvent("onboarding.step_view", properties: [
            "step": step,
            "step_name": stepName
        ])
    }

    /// 온보딩 완료
    func logOnboardingComplete() {
        logEvent("onboarding.complete", properties: [:])
    }

    /// 온보딩 건너뛰기
    /// - Parameter step: 건너뛴 단계
    func logOnboardingSkip(step: Int) {
        logEvent("onboarding.skip", properties: [
            "step": step
        ])
    }
}

// MARK: - Learning Events (학습 관련)
@MainActor
public extension AmplitudeManager {

    /// 학습 세션 시작
    /// - Parameters:
    ///   - lessonId: 레슨 ID
    ///   - lessonType: 레슨 타입
    func logLessonStart(lessonId: String, lessonType: String) {
        logEvent("lesson.start", properties: [
            "lesson_id": lessonId,
            "lesson_type": lessonType
        ])
    }

    /// 학습 세션 완료
    /// - Parameters:
    ///   - lessonId: 레슨 ID
    ///   - score: 점수
    ///   - duration: 소요 시간
    func logLessonComplete(lessonId: String, score: Int, duration: TimeInterval) {
        logEvent("lesson.complete", properties: [
            "lesson_id": lessonId,
            "score": score,
            "duration_seconds": Int(duration)
        ])
    }
}

// MARK: - Purchase Events (구매 관련)
@MainActor
public extension AmplitudeManager {

    /// 구매 화면 진입
    /// - Parameter productId: 상품 ID
    func logPurchaseScreenView(productId: String) {
        logEvent("purchase.screen_view", properties: [
            "product_id": productId
        ])
    }

    /// 구매 시작
    /// - Parameter productId: 상품 ID
    func logPurchaseStart(productId: String) {
        logEvent("purchase.start", properties: [
            "product_id": productId
        ])
    }

    /// 구매 완료
    /// - Parameters:
    ///   - productId: 상품 ID
    ///   - amount: 금액
    ///   - currency: 통화
    func logPurchaseComplete(productId: String, amount: Double, currency: String) {
        logEvent("purchase.complete", properties: [
            "product_id": productId,
            "amount": amount,
            "currency": currency
        ])
    }

    /// 구매 실패
    /// - Parameters:
    ///   - productId: 상품 ID
    ///   - error: 에러 메시지
    func logPurchaseFail(productId: String, error: String) {
        logEvent("purchase.fail", properties: [
            "product_id": productId,
            "error": error
        ])
    }
}

// MARK: - Settings Events (설정 관련)
@MainActor
public extension AmplitudeManager {

    /// 설정 변경
    /// - Parameters:
    ///   - settingName: 설정 이름
    ///   - newValue: 새로운 값
    func logSettingChange(settingName: String, newValue: Any) {
        logEvent("settings.change", properties: [
            "setting_name": settingName,
            "new_value": "\(newValue)"
        ])
    }

    /// 알림 설정 변경
    /// - Parameter enabled: 활성화 여부
    func logNotificationSettingChange(enabled: Bool) {
        logEvent("settings.notification_change", properties: [
            "enabled": enabled
        ])
    }
}
