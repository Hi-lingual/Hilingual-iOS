//
//  AnalyticsEvent.swift
//  HilingualCore
//

import Foundation

public enum AnalyticsEvent {
    case pageviewFeed(entryId: String)
    case pageviewPostedDiary(entryId: String)
    case pageviewFeedback(page: Page)
    case pageviewDiaryWriting(
        entryId: String,
        backSource: BackSource,
        selectedDate: Date,
        recommendedTopic: RecommendedTopic
    )
    case refreshTriggered(entryId: String, method: RefreshMethod)
    case viewProfileUser(
        profileUserId: String,
        entrySource: EntrySource,
        entryId: String,
        page: Page
    )
    case clickEmpathyAction(entryId: String, action: EmpathyAction)
    case clickModal(entryId: String, action: ModalAction)
    case clickScanText(entryId: String)
    case clickDropdown(entryId: String, recommendedTopic: RecommendedTopic, clickCount: Int)
    case submittedEntryDiary(
        entryId: String,
        hasPhoto: Bool,
        charCount: Int,
        aiRequestStartTime: TimeInterval
    )
    case clickBackDiary(entryId: String, backSource: BackSource)
    case clickTextfield(entryId: String, inputType: TextInputType, timeToFirstInput: Int)
    case clickFeedbackToggle(page: Page, toggleClickCount: Int, toggleState: Bool)
    case bookmarkAction(entryId: String, entrySource: EntrySource, action: BookmarkAction)
    case toastAction(action: ToastAction, toastId: ToastId, entryId: String)
    case clickBackFeedback(entryId: String, backSource: BackSource)
    case submittedPostDiary(entryId: String)
    case clickVocabReviewBtn
    case clickVocabPronunciationBtn(isFirstPlay: Bool)
    case clickDiaryPronunciationBtn(isFirstPlay: Bool)
    case clickErrorCTA(page: Page, action: ErrorCTAAction)
}

extension AnalyticsEvent {
    public var caseDescription: String {
        String(describing: self)
    }

    var name: String {
        switch self {
        case .pageviewFeed,
             .pageviewPostedDiary,
             .pageviewFeedback,
             .pageviewDiaryWriting:
            return "pageview"
        case .viewProfileUser:
            return "view_profile_user"
        case let .clickErrorCTA(page, action):
            return "click_\(page.analyticsPropertyName).\(action.rawValue)"
        default:
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
        case let .pageviewFeed(entryId):
            return [
                "entry_id": entryId,
                "tab_name": TabName.feed.analyticsPropertyName
            ]
        case let .pageviewPostedDiary(entryId):
            return [
                "entry_id": entryId,
                "tab_name": TabName.postedDiary.analyticsPropertyName
            ]
        case let .pageviewFeedback(page):
            return [
                "page": page.analyticsPropertyName
            ]
        case let .pageviewDiaryWriting(entryId, backSource, selectedDate, recommendedTopic):
            return [
                "entry_id": entryId,
                "back_source": backSource.analyticsPropertyName,
                "selected_date": Self.formatDate(selectedDate),
                "recommen_topic": recommendedTopic.dictionary
            ]
        case let .refreshTriggered(entryId, method):
            return [
                "entry_id": entryId,
                "refresh_method": method.analyticsPropertyName
            ]
        case let .viewProfileUser(profileUserId, entrySource, entryId, page):
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
        case let .clickModal(entryId, action):
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
        case let .submittedEntryDiary(entryId, hasPhoto, charCount, aiRequestStartTime):
            return [
                "entry_id": entryId,
                "has_photo": hasPhoto,
                "char_count": charCount,
                "ai_request_start_time": aiRequestStartTime
            ]
        case let .clickBackDiary(entryId, backSource):
            return [
                "entry_id": entryId,
                "back_source": backSource.analyticsPropertyName
            ]
        case let .clickTextfield(entryId, inputType, timeToFirstInput):
            return [
                "entry_id": entryId,
                "text_input_type": inputType.analyticsPropertyName,
                "time_to_first_input": timeToFirstInput
            ]
        case let .clickFeedbackToggle(page, toggleClickCount, toggleState):
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
        case let .toastAction(action, toastId, entryId):
            return [
                "toast_action": action.analyticsPropertyName,
                "toast_id": toastId.analyticsPropertyName,
                "entry_id": entryId
            ]
        case let .clickBackFeedback(entryId, backSource):
            return [
                "entry_id": entryId,
                "back_source": backSource.analyticsPropertyName
            ]
        case let .submittedPostDiary(entryId):
            return [
                "entry_id": entryId
            ]
        case .clickVocabReviewBtn:
            return [
                "page": Page.vocabulary.analyticsPropertyName,
                "section": Section.vocabCard.analyticsPropertyName
            ]
        case let .clickVocabPronunciationBtn(isFirstPlay):
            return [
                "page": Page.vocabulary.analyticsPropertyName,
                "section": Section.vocabCard.analyticsPropertyName,
                "is_first_play": isFirstPlay
            ]
        case let .clickDiaryPronunciationBtn(isFirstPlay):
            return [
                "page": Page.feedback.analyticsPropertyName,
                "is_first_play": isFirstPlay
            ]
        case let .clickErrorCTA(page, _):
            return [
                "page": page.analyticsPropertyName
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
        case unknown
        case custom(String)

        public static func from(_ value: String) -> EntrySource {
            switch value {
            case "feed": return .feed
            case "user_profile": return .userProfile
            case "notification": return .notification
            case "unknown": return .unknown
            default: return .custom(value)
            }
        }

        var analyticsPropertyName: String {
            switch self {
            case .feed: return "feed"
            case .userProfile: return "user_profile"
            case .notification: return "notification"
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
        case dataNotFoundGoBack = "data_not_found_go_back"
        case serverErrorRetry = "server_error_retry"
        case serverErrorGoBack = "server_error_go_back"
        case serverErrorConfirm = "server_error_confirm"
        case networkErrorRetry = "network_error_retry"
        case feedbackRetry = "feedback_retry"
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

        var analyticsPropertyName: String { rawValue }
    }

    public enum ToastId: String, Sendable {
        case diaryPostSuccess = "diary_post_success"

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

    private static func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}
