//
//  AnalyticsEvent.swift
//  HilingualCore
//

import Foundation

public enum AnalyticsEvent {
    case pageviewFeed(entryId: String)
    case pageviewPostedDiary(entryId: String)
    case pageviewFeedback
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
    case clickFeedbackToggle(clickCount: Int, isEnabled: Bool)
    case bookmarkAction(entryId: String, entrySource: EntrySource, action: BookmarkAction)
    case toastAction(action: ToastAction, toastId: ToastId, entryId: String)
    case clickBackFeedback(entryId: String, backSource: BackSource)
    case submittedPostDiary(entryId: String)
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
            return "viewe_profile_user"
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
        case .pageviewFeedback:
            return [
                "page": Page.feedback.analyticsPropertyName
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
        case let .clickFeedbackToggle(clickCount, isEnabled):
            return [
                "toggle_click_count": clickCount,
                "toggle_state": isEnabled
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
        case feed
        case userProfile
        case notification
        case feedback
        case custom(String)

        var analyticsPropertyName: String {
            switch self {
            case .feed: return "feed"
            case .userProfile: return "user_profile"
            case .notification: return "notification"
            case .feedback: return "feedback"
            case .custom(let value): return value
            }
        }
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
