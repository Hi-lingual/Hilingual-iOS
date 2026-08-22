//
//  RecommendedTopicWidget.swift
//  HilingualWidget
//
//  Created by youngseo on 8/22/26.
//

import SwiftUI
import WidgetKit

// MARK: - Model

struct RecommendedTopicWidgetEntry: TimelineEntry {
    let date: Date
    let isWritten: Bool
    let topicEn: String
}

// MARK: - Provider

struct RecommendedTopicWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> RecommendedTopicWidgetEntry {
        .default
    }

    func getSnapshot(in context: Context, completion: @escaping (RecommendedTopicWidgetEntry) -> Void) {
        completion(.default)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<RecommendedTopicWidgetEntry>) -> Void) {
        let nextRefreshDate = Calendar.current.date(byAdding: .hour, value: 1, to: .now) ?? .now
        completion(Timeline(entries: [.default], policy: .after(nextRefreshDate)))
    }
}

// MARK: - View

struct RecommendedTopicWidgetEntryView: View {
    @Environment(\.widgetFamily) private var family
    @Environment(\.colorScheme) private var colorScheme

    let entry: RecommendedTopicWidgetEntry

    var body: some View {
        VStack(spacing: 0) {
            headerView
            contentView
        }
        .containerBackground(for: .widget) {
            contentBackgroundColor
        }
    }

    private var headerView: some View {
        HStack(spacing: 4) {
            Text(formattedDate)
                .font(layout.textFont)
                .foregroundStyle(dateColor)

            if isMediumFamily {
                Text("·")
                    .font(layout.textFont)
                    .foregroundStyle(.gray400)

                Text(statusText)
                    .font(.pretendard(.body_m_14))
                    .foregroundStyle(statusColor)
            }

            Spacer(minLength: 0)

            if isMediumFamily {
                remainingTimeView
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(headerBackgroundColor)
    }

    private var contentView: some View {
        VStack(alignment: .leading, spacing: 0) {
            if isMediumFamily {
                Text("오늘의 추천 주제")
                    .font(.pretendard(.body_m_12))
                    .foregroundStyle(contentTitleColor)
                    .padding(.bottom, 8)
            }

            Text(entry.topicEn)
                .font(layout.textFont)
                .foregroundStyle(topicColor)
                .lineLimit(layout.topicLineLimit)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)

            Spacer(minLength: 0)

            if !isMediumFamily {
                remainingTimeView
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(layout.contentInsets)
        .background(contentBackgroundColor)
    }

    private var remainingTimeView: some View {
        HStack(spacing: 4) {
            Image(.icTime16)

            Text("\(Date().widgetRemainingHoursInTwoDays)시간 남음")
                .font(.pretendard(.body_m_12))
                .foregroundStyle(remainingTimeColor)
        }
    }

    private var formattedDate: String {
        Date().widgetMonthDayWeekdayText
    }

    private var statusText: String {
        entry.isWritten ? "작성완료" : "미작성"
    }

    private var dateColor: Color {
        colorScheme == .dark ? .gray200 : .white
    }

    private var statusColor: Color {
        entry.isWritten ? .hilingualOrange : .gray400
    }

    private var headerBackgroundColor: Color {
        colorScheme == .dark ? .black : .hilingualBlack
    }

    private var contentBackgroundColor: Color {
        colorScheme == .dark ? .gray850 : .gray100
    }

    private var contentTitleColor: Color {
        colorScheme == .dark ? .gray400 : .gray500
    }

    private var topicColor: Color {
        colorScheme == .dark ? .white : .black
    }

    private var remainingTimeColor: Color {
        colorScheme == .dark ? .gray200 : .gray500
    }

    private var isMediumFamily: Bool {
        family == .systemMedium
    }

    private var layout: RecommendedTopicWidgetLayout {
        isMediumFamily ? .medium : .small
    }
}

// MARK: - Layout

private enum RecommendedTopicWidgetLayout {
    case small
    case medium

    var contentInsets: EdgeInsets {
        switch self {
        case .small:
            EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
        case .medium:
            EdgeInsets(top: 25.5, leading: 20, bottom: 33.5, trailing: 20)
        }
    }

    var textFont: Font {
        switch self {
        case .small: .pretendard(.body_m_14)
        case .medium: .pretendard(.body_m_16)
        }
    }

    var topicLineLimit: Int {
        switch self {
        case .small: 3
        case .medium: 2
        }
    }

}

// MARK: - Widget
// TODO: 수아언니한테 확인받고 문구 교체!

struct RecommendedTopicWidget: Widget {
    let kind = "RecommendedTopicWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: RecommendedTopicWidgetProvider()) { entry in
            RecommendedTopicWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("추천 주제")
        .description("오늘의 영어 일기 주제를 확인해요.")
        .supportedFamilies([.systemSmall, .systemMedium])
        .contentMarginsDisabled()
    }
}

// MARK: - Extensions

private extension RecommendedTopicWidgetEntry {
    static let `default` = RecommendedTopicWidgetEntry(
        date: .now,
        isWritten: false,
        topicEn: "What surprised you today?"
    )

    static let written = RecommendedTopicWidgetEntry(
        date: .now,
        isWritten: true,
        topicEn: "What surprised you today?"
    )

    static let longTopic = RecommendedTopicWidgetEntry(
        date: .now,
        isWritten: true,
        topicEn: "What is something small that made you smile today?"
    )
}

// MARK: - Preview

#Preview("Topic Unwritten Medium", as: .systemMedium) {
    RecommendedTopicWidget()
} timeline: {
    RecommendedTopicWidgetEntry.default
}

#Preview("Topic Written Medium", as: .systemMedium) {
    RecommendedTopicWidget()
} timeline: {
    RecommendedTopicWidgetEntry.written
}

#Preview("Topic Long Medium", as: .systemMedium) {
    RecommendedTopicWidget()
} timeline: {
    RecommendedTopicWidgetEntry.longTopic
}

#Preview("Topic Unwritten Small", as: .systemSmall) {
    RecommendedTopicWidget()
} timeline: {
    RecommendedTopicWidgetEntry.default
}

#Preview("Topic Written Small", as: .systemSmall) {
    RecommendedTopicWidget()
} timeline: {
    RecommendedTopicWidgetEntry.written
}

#Preview("Topic Long Small", as: .systemSmall) {
    RecommendedTopicWidget()
} timeline: {
    RecommendedTopicWidgetEntry.longTopic
}
