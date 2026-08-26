//
//  AnalyticsEvent.swift
//  HilingualCore
//

import Foundation

public enum AnalyticsEvent {
    // MARK: 공통 (화면 비종속: page 프로퍼티로 진입 화면 추적)
    case viewPage(page: Page)
    case clickEmpathyAction(entryId: String, action: EmpathyAction)
    case clickDropdown(entryId: String, recommendedTopic: RecommendedTopic, clickCount: Int)
    case bookmarkAction(entryId: String, entrySource: EntrySource, action: BookmarkAction)
    case toastAction(action: ToastAction, toastId: ToastId, entryId: String? = nil, page: Page? = nil)
    case clickBack(entryId: String, backSource: BackSource, page: Page)
    case clickVocabPronunciationBtnPlay(isFirstPlay: Bool, page: Page)
    case clickDiaryPronunciationBtnPlay(isFirstPlay: Bool, page: Page)
    case clickPushNotification(notificationType: NotificationType, page: Page)
    case viewAdAction(result: AdResult, page: Page)

    // MARK: 화면 종속 ({trigger}_{screen}.{event})
    case clickProfileView(
        profileUserId: String,
        entrySource: EntrySource,
        entryId: String,
        page: Page
    )
    case clickRefresh(entryId: String, method: RefreshMethod, page: Page)
    case clickToggle(page: Page, toggleClickCount: Int, toggleState: Bool)
    case clickScanText(entryId: String)
    case clickBackModal(entryId: String, action: ModalAction)
    case clickTextfield(entryId: String, inputType: TextInputType, timeToFirstInput: Int)
    case clickSubmitEntry(
        entryId: String,
        hasPhoto: Bool,
        charCount: Int,
        aiRequestStartTime: TimeInterval,
        aiResponseReceivedTime: TimeInterval? = nil
    )
    case clickPostDiary(entryId: String)
    case clickVocabularyReviewBtn
    case clickVocabularyUnknownFilter
    case clickVocabularySortChanged(previousSortType: VocabSortType, sortType: VocabSortType)
    case clickVocaLookup(page: Page)
    case clickHomeMoreMenu(menuName: HomeMenuName)
    case clickHomeDiaryView(entryId: String, entrySource: EntrySource, openTime: TimeInterval)
    case clickHomeDiaryWrite(openTime: TimeInterval)
    case clickHomeProfile
    case clickHomeSwitchLanguage
    case clickHomeStreakRevive
    case clickOnboardingSkip(onboardingStep: Int)
    case clickErrorCTA(page: Page, action: ErrorCTAAction)
    case clickWidget(widgetType: WidgetType)
    case widgetCount(diaryTopicCount: Int, streakCount: Int, totalCount: Int)
}

extension AnalyticsEvent {
    public var caseDescription: String {
        String(describing: self)
    }

    var name: String {
        switch self {
        case .viewPage:
            return "view_page"
        case let .clickProfileView(_, _, _, page):
            return "click_\(page.analyticsPropertyName).profile_view"
        case let .clickRefresh(_, _, page):
            return "click_\(page.analyticsPropertyName).refresh"
        case let .clickToggle(page, _, _):
            return "click_\(page.analyticsPropertyName).toggle"
        case .clickScanText:
            return "click_write_diary.scan_text"
        case .clickBackModal:
            return "click_write_diary.back_modal"
        case .clickTextfield:
            return "click_write_diary.textfield"
        case .clickSubmitEntry:
            return "click_write_diary.submit_entry"
        case .clickPostDiary:
            return "click_feedback.post_diary"
        case .clickVocabularyReviewBtn:
            return "click_vocabulary.review_btn"
        case .clickVocabularyUnknownFilter:
            return "click_vocabulary.unknown_filter"
        case .clickVocabularySortChanged:
            return "click_vocabulary.sort_changed"
        case .clickVocaLookup:
            return "click_vocabulary.voca_lookup"
        case .clickHomeMoreMenu:
            return "click_home.more_menu"
        case .clickHomeDiaryView:
            return "click_home.diary_view"
        case .clickHomeDiaryWrite:
            return "click_home.diary_write"
        case .clickHomeProfile:
            return "click_home.profile"
        case .clickHomeSwitchLanguage:
            return "click_home.switch_language"
        case .clickHomeStreakRevive:
            return "click_home.streak_revive"
        case .clickOnboardingSkip:
            return "click_onboarding.skip"
        case let .clickErrorCTA(page, action):
            return "click_\(page.analyticsPropertyName).\(action.rawValue)"
        case .clickWidget:
            return "click_widget"
        case .widgetCount:
            return "widget_count"
        default:
            // 공통 이벤트: caseName을 snake_case로 변환
            // (click_back, click_empathy_action, click_dropdown, bookmark_action,
            //  toast_action, click_vocab_pronunciation_btn_play,
            //  click_diary_pronunciation_btn_play, click_push_notification, view_ad_action)
            return snakeCaseName
        }
    }

    private var caseName: String {
        caseDescription.split(separator: "(").first.map(String.init) ?? caseDescription
    }

    private var snakeCaseName: String {
        caseName.camelToSnakeCased
    }

    var properties: [String: Any]? {
        switch self {
        case let .viewPage(page):
            return [
                "page": page.analyticsPropertyName
            ]
        case let .clickRefresh(entryId, method, _):
            return [
                "entry_id": entryId,
                "refresh_method": method.analyticsPropertyName
            ]
        case let .clickProfileView(profileUserId, entrySource, entryId, page):
            return [
                "profile_user_id": profileUserId,
                "entry_source": entrySource.analyticsPropertyName,
                "entry_id": entryId,
                "page": page.analyticsPropertyName
            ]
        case let .clickEmpathyAction(entryId, action):
            return [
                "entry_id": entryId,
                "empathy_action": action.analyticsPropertyName
            ]
        case let .clickBackModal(entryId, action):
            return [
                "entry_id": entryId,
                "modal_action": action.analyticsPropertyName
            ]
        case let .clickScanText(entryId):
            return [
                "entry_id": entryId
            ]
        case let .clickDropdown(entryId, recommendedTopic, clickCount):
            return [
                "entry_id": entryId,
                "recommen_topic": recommendedTopic.dictionary,
                "dropdown_click_count": clickCount
            ]
        case let .clickSubmitEntry(entryId, hasPhoto, charCount, aiRequestStartTime, aiResponseReceivedTime):
            var props: [String: Any] = [
                "entry_id": entryId,
                "has_photo": hasPhoto,
                "char_count": charCount,
                "ai_request_start_time": aiRequestStartTime
            ]
            if let aiResponseReceivedTime {
                props["ai_response_received_time"] = aiResponseReceivedTime
            }
            return props
        case let .clickBack(entryId, backSource, page):
            return [
                "entry_id": entryId,
                "back_source": backSource.analyticsPropertyName,
                "page": page.analyticsPropertyName
            ]
        case let .clickTextfield(entryId, inputType, timeToFirstInput):
            return [
                "entry_id": entryId,
                "text_input_type": inputType.analyticsPropertyName,
                "time_to_first_input": timeToFirstInput
            ]
        case let .clickToggle(page, toggleClickCount, toggleState):
            return [
                "page": page.analyticsPropertyName,
                "toggle_click_count": toggleClickCount,
                "toggle_state": toggleState
            ]
        case let .bookmarkAction(entryId, entrySource, action):
            return [
                "entry_id": entryId,
                "entry_source": entrySource.analyticsPropertyName,
                "bookmark_action": action.analyticsPropertyName
            ]
        case let .toastAction(action, toastId, entryId, page):
            var props: [String: Any] = [
                "toast_action": action.analyticsPropertyName,
                "toast_id": toastId.analyticsPropertyName
            ]
            if let entryId {
                props["entry_id"] = entryId
            }
            if let page {
                props["page"] = page.analyticsPropertyName
            }
            return props
        case let .clickPostDiary(entryId):
            return [
                "entry_id": entryId
            ]
        case .clickVocabularyReviewBtn:
            return [
                "page": Page.vocabulary.analyticsPropertyName,
                "section": Section.vocabCard.analyticsPropertyName
            ]
        case .clickVocabularyUnknownFilter:
            return [
                "page": Page.vocabulary.analyticsPropertyName
            ]
        case let .clickVocabularySortChanged(previousSortType, sortType):
            return [
                "previous_sort_type": previousSortType.analyticsPropertyName,
                "sort_type": sortType.analyticsPropertyName
            ]
        case let .clickVocaLookup(page):
            return [
                "page": page.analyticsPropertyName
            ]
        case let .clickVocabPronunciationBtnPlay(isFirstPlay, page):
            return [
                "page": page.analyticsPropertyName,
                "section": Section.vocabCard.analyticsPropertyName,
                "is_first_play": isFirstPlay
            ]
        case let .clickDiaryPronunciationBtnPlay(isFirstPlay, page):
            return [
                "page": page.analyticsPropertyName,
                "is_first_play": isFirstPlay
            ]
        case let .clickHomeMoreMenu(menuName):
            return [
                "menu_name": menuName.analyticsPropertyName
            ]
        case let .clickHomeDiaryView(entryId, entrySource, openTime):
            return [
                "entry_id": entryId,
                "entry_source": entrySource.analyticsPropertyName,
                "open_time": openTime
            ]
        case let .clickHomeDiaryWrite(openTime):
            return [
                "open_time": openTime
            ]
        case .clickHomeProfile:
            return nil
        case .clickHomeSwitchLanguage:
            return nil
        case .clickHomeStreakRevive:
            return nil
        case let .clickOnboardingSkip(onboardingStep):
            return [
                "onboarding_step": onboardingStep
            ]
        case let .clickPushNotification(notificationType, page):
            return [
                "notification_type": notificationType.analyticsPropertyName,
                "page": page.analyticsPropertyName
            ]
        case let .viewAdAction(result, page):
            return [
                "ad_result": result.analyticsPropertyName,
                "page": page.analyticsPropertyName
            ]
        case let .clickErrorCTA(page, _):
            return [
                "page": page.analyticsPropertyName
            ]
        case let .clickWidget(widgetType):
            return [
                "widget_type": widgetType.analyticsPropertyName
            ]
        case let .widgetCount(diaryTopicCount, streakCount, totalCount):
            return [
                "widget_count_diary_topic": diaryTopicCount,
                "widget_count_streak": streakCount,
                "widget_count_total": totalCount
            ]
        }
    }

    public struct RecommendedTopic: Sendable {
        public let kor: String
        public let en: String

        public init(kor: String?, en: String?) {
            self.kor = kor ?? ""
            self.en = en ?? ""
        }

        public static func from(_ value: (String, String)?) -> RecommendedTopic {
            RecommendedTopic(kor: value?.0, en: value?.1)
        }

        var dictionary: [String: String] {
            [
                "kor": kor,
                "en": en
            ]
        }
    }

    public enum TabName: String, Sendable {
        case feed = "feed"
        case postedDiary = "posted_diary"

        var analyticsPropertyName: String { rawValue }
    }

    public enum EntrySource: Sendable {
        case feed
        case userProfile
        case notification
        case home
        case unknown
        case custom(String)

        public static func from(_ value: String) -> EntrySource {
            switch value {
            case "feed": return .feed
            case "user_profile": return .userProfile
            case "notification": return .notification
            case "home": return .home
            case "unknown": return .unknown
            default: return .custom(value)
            }
        }

        var analyticsPropertyName: String {
            switch self {
            case .feed: return "feed"
            case .userProfile: return "user_profile"
            case .notification: return "notification"
            case .home: return "home"
            case .unknown: return "unknown"
            case .custom(let value): return value
            }
        }
    }

    public enum Page: Sendable {
        case home
        case feed
        case userProfile
        case feedProfile
        case myFeed
        case notification
        case notificationSetting
        case notificationDetail
        case feedback
        case feedbackLoading
        case postedDiary
        case vocabulary
        case writeDiary
        case aiFeedback
        case myPage
        case editProfile
        case nicknameEdit
        case blockUser
        case followList
        case onboarding
        case custom(String)

        var analyticsPropertyName: String {
            switch self {
            case .home: return "home"
            case .feed: return "feed"
            case .userProfile: return "user_profile"
            case .feedProfile: return "feed_profile"
            case .myFeed: return "my_feed"
            case .notification: return "notification"
            case .notificationSetting: return "notification_setting"
            case .notificationDetail: return "notification_detail"
            case .feedback: return "feedback"
            case .feedbackLoading: return "feedback_loading"
            case .postedDiary: return "posted_diary"
            case .vocabulary: return "vocabulary"
            case .writeDiary: return "write_diary"
            case .aiFeedback: return "ai_feedback"
            case .myPage: return "mypage"
            case .editProfile: return "edit_profile"
            case .nicknameEdit: return "nickname_edit"
            case .blockUser: return "block_user"
            case .followList: return "follow_list"
            case .onboarding: return "onboarding"
            case .custom(let value): return value
            }
        }
    }

    public enum ErrorCTAAction: String, Sendable {
        case emptyDataConfirm = "empty_data_confirm"
        case serverErrorRetry = "server_error_retry"
        case serverErrorGoBack = "server_error_go_back"
        case serverErrorConfirm = "server_error_confirm"
        case networkErrorRetry = "network_error_retry"
    }

    public enum NotificationType: String, Sendable {
        case reminderDaily = "reminder_daily"
        case friendFollow = "friend_follow"
        case diaryEmpathy = "diary_empathy"

        var analyticsPropertyName: String { rawValue }
    }

    public enum WidgetType: String, Sendable {
        case diaryTopic = "diary_topic"
        case streak = "streak"

        public static func from(_ value: String?) -> WidgetType? {
            guard let value else { return nil }

            switch value {
            case "diary_topic": return .diaryTopic
            case "streak": return .streak
            default: return nil
            }
        }

        var analyticsPropertyName: String { rawValue }
    }

    public enum AdResult: String, Sendable {
        case completed = "completed"
        case dismissed = "dismissed"
        case failed = "failed"

        var analyticsPropertyName: String { rawValue }
    }

    public enum VocabSortType: String, Sendable {
        case latest = "latest"
        case alphabetical = "alphabetical"

        var analyticsPropertyName: String { rawValue }
    }

    public enum HomeMenuName: String, Sendable {
        case publish = "publish"
        case unpublish = "unpublish"
        case delete = "delete"

        var analyticsPropertyName: String { rawValue }
    }

    public enum Section: String, Sendable {
        case vocabCard = "vocab_card"

        var analyticsPropertyName: String { rawValue }
    }

    public enum BackSource: Sendable {
        case uiButton
        case unknown
        case custom(String)

        public static func from(_ value: String) -> BackSource {
            switch value {
            case "ui_button": return .uiButton
            case "unknown": return .unknown
            default: return .custom(value)
            }
        }

        var analyticsPropertyName: String {
            switch self {
            case .uiButton: return "ui_button"
            case .unknown: return "unknown"
            case .custom(let value): return value
            }
        }
    }

    public enum RefreshMethod: String, Sendable {
        case auto = "auto"
        case pullToRefresh = "pull_to_refresh"

        var analyticsPropertyName: String { rawValue }
    }

    public enum EmpathyAction: String, Sendable {
        case add = "add"
        case remove = "remove"

        var analyticsPropertyName: String { rawValue }
    }

    public enum ModalAction: String, Sendable {
        case continueWriting = "continue_writing"
        case confirmExit = "confirm_exit"

        var analyticsPropertyName: String { rawValue }
    }

    public enum BookmarkAction: String, Sendable {
        case add = "add"
        case remove = "remove"

        var analyticsPropertyName: String { rawValue }
    }

    public enum ToastAction: String, Sendable {
        case ctaClick = "cta_click"
        case autoDismiss = "auto_dismiss"
        case gotoVoca = "goto_voca"

        var analyticsPropertyName: String { rawValue }
    }

    public enum ToastId: String, Sendable {
        case diaryPostSuccess = "diary_post_success"
        case vocaAddSuccess = "voca_add_success"

        var analyticsPropertyName: String { rawValue }
    }

    public enum TextInputType: Sendable {
        case typed
        case custom(String)

        var analyticsPropertyName: String {
            switch self {
            case .typed: return "typed"
            case .custom(let value): return value
            }
        }
    }
}
