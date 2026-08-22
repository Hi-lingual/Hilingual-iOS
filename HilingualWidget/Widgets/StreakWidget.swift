//
//  StreakWidget.swift
//  HilingualWidget
//
//  Created by youngseo on 8/22/26.
//

import SwiftUI
import WidgetKit

// MARK: - Model

struct StreakWidgetEntry: TimelineEntry {
    let date: Date
    let isLoggedIn: Bool
    let streak: Int
    let writtenWeekdays: [Bool]
}

// MARK: - Provider

struct StreakWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> StreakWidgetEntry {
        StreakWidgetEntry.default
    }

    func getSnapshot(in context: Context, completion: @escaping (StreakWidgetEntry) -> Void) {
        completion(.default)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<StreakWidgetEntry>) -> Void) {
        let nextRefreshDate = Calendar.current.date(byAdding: .hour, value: 1, to: .now) ?? .now
        completion(Timeline(entries: [.default], policy: .after(nextRefreshDate)))
    }
}

// MARK: - View

struct StreakWidgetEntryView: View {
    @Environment(\.widgetFamily) private var family
    @Environment(\.colorScheme) private var colorScheme

    let entry: StreakWidgetEntry

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            groundView
            contentStack
            imageView
        }
        .containerBackground(for: .widget) {
            backgroundColor
        }
    }

    private var contentStack: some View {
        VStack(alignment: .leading, spacing: 0) {
            titleText
            streakStatusView
                .padding(.top, statusTopPadding)

            if layout.showsWeekdays {
                Spacer(minLength: weekdayTopSpacing)

                StreakWeekdayRow(
                    writtenWeekdays: entry.writtenWeekdays,
                    isLoggedIn: entry.isLoggedIn
                )
            } else {
                Spacer(minLength: 0)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(layout.contentInsets)
    }

    private var titleText: some View {
        Text("연속 작성")
            .font(layout.titleFont)
            .foregroundStyle(titleColor)
    }

    @ViewBuilder
    private var streakStatusView: some View {
        if entry.isLoggedIn {
            StreakCountView(
                streak: entry.streak,
                iconResource: layout.countIconResource(isEmptyStreak: entry.streak == 0),
                iconSize: layout.countIconSize,
                font: layout.countFont,
                textColor: primaryTextColor
            )
        } else {
            StreakLoginPlaceholder(
                size: layout.placeholderSize,
                textColor: primaryTextColor
            )
        }
    }

    private var statusTopPadding: CGFloat {
        entry.isLoggedIn ? layout.countTopPadding : layout.placeholderTopPadding
    }

    private var weekdayTopSpacing: CGFloat {
        entry.isLoggedIn && entry.streak > 0 ? 25 : 19
    }

    private var imageView: some View {
        StreakImageView(
            isLoggedIn: entry.isLoggedIn,
            streak: entry.streak,
            family: family
        )
        .frame(width: layout.imageWidth)
        .padding(layout.contentInsets)
    }

    @ViewBuilder
    private var groundView: some View {
        if layout.showsGround {
            Image(groundImageResource)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .offset(y: layout.groundBottomOffset)
        }
    }

    private var groundImageResource: ImageResource {
        colorScheme == .dark ? .imgWidgetGrayground2X2 : .imgWidgetLightground2X2
    }

    private var titleColor: Color {
        colorScheme == .dark ? .gray200 : .gray500
    }

    private var primaryTextColor: Color {
        colorScheme == .dark ? .white : .hilingualBlack
    }

    private var backgroundColor: Color {
        colorScheme == .dark ? .gray700 : .gray100
    }

    private var layout: StreakWidgetLayout {
        family == .systemMedium ? .medium : .small
    }
}

// MARK: - Layout

private enum StreakWidgetLayout {
    case small
    case medium

    var contentInsets: EdgeInsets {
        switch self {
        case .small:
            EdgeInsets(top: 16, leading: 16, bottom: 8, trailing: 16)
        case .medium:
            EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        }
    }

    var titleFont: Font {
        switch self {
        case .small: .pretendard(.body_m_12)
        case .medium: .pretendard(.body_m_14)
        }
    }

    var countFont: Font {
        switch self {
        case .small: .pretendard(.head_b_26)
        case .medium: .pretendard(.head_b_36)
        }
    }

    var countTopPadding: CGFloat {
        switch self {
        case .small: 2
        case .medium: 4
        }
    }

    var placeholderTopPadding: CGFloat {
        5
    }

    var showsWeekdays: Bool {
        self == .medium
    }

    var showsGround: Bool {
        self == .small
    }

    var groundBottomOffset: CGFloat {
        switch self {
        case .small: 1
        case .medium: 0
        }
    }

    var placeholderSize: StreakLoginPlaceholder.Size {
        switch self {
        case .small: .small
        case .medium: .medium
        }
    }

    var countIconSize: CGFloat {
        switch self {
        case .small: 28
        case .medium: 40
        }
    }

    func countIconResource(isEmptyStreak: Bool) -> ImageResource {
        switch (self, isEmptyStreak) {
        case (.small, true):
            .icFireEmpty28
        case (.small, false):
            .icFireFill28
        case (.medium, true):
            .icFireEmpty40
        case (.medium, false):
            .icFireFill40
        }
    }

    var imageWidth: CGFloat {
        switch self {
        case .small: 107
        case .medium: 130
        }
    }
}

// MARK: - Widget
// TODO: 수아언니한테 확인받고 문구 교체!

struct StreakWidget: Widget {
    let kind = "StreakWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: StreakWidgetProvider()) { entry in
            StreakWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("연속 학습")
        .description("하이링구얼 연속 학습일을 확인해요.")
        .supportedFamilies([.systemSmall, .systemMedium])
        .contentMarginsDisabled()
    }
}

// MARK: - Components

private struct StreakLoginPlaceholder: View {
    enum Size {
        case small
        case medium
    }

    let size: Size
    let textColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            if size == .medium {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray300)
                    .frame(width: 93, height: 26)
            }

            Text("로그인 후 확인 가능")
                .font(textFont)
                .foregroundStyle(textColor)
        }
    }

    private var textFont: Font {
        switch size {
        case .small: .pretendard(.body_m_12)
        case .medium: .pretendard(.body_sb_14)
        }
    }
}

private struct StreakCountView: View {
    let streak: Int
    let iconResource: ImageResource
    let iconSize: CGFloat
    let font: Font
    let textColor: Color

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Image(iconResource)
                .resizable()
                .scaledToFit()
                .frame(width: iconSize, height: iconSize)

            Text("\(streak)")
                .font(font)
                .foregroundStyle(textColor)
                .contentTransition(.numericText())
        }
    }
}

private struct StreakImageView: View {
    let isLoggedIn: Bool
    let streak: Int
    let family: WidgetFamily

    var body: some View {
        Image(imageResource)
            .resizable()
            .scaledToFit()
    }

    private var imageResource: ImageResource {
        switch (family, isEmptyStreak) {
        case (.systemMedium, true):
            .imgWidget24X2
        case (.systemMedium, false):
            .imgWidget14X2
        case (_, true):
            .imgWidget22X2
        case (_, false):
            .imgWidget12X2
        }
    }

    private var isEmptyStreak: Bool {
        isLoggedIn && streak == 0
    }
}

// TODO: 프리뷰 지우기
// MARK: - Extensions

private extension StreakWidgetEntry {
    static let `default` = StreakWidgetEntry(
        date: .now,
        isLoggedIn: true,
        streak: 4,
        writtenWeekdays: [false, true, true, true, true]
    )
}

// MARK: - Preview

#Preview("Streak N Medium", as: .systemMedium) {
    StreakWidget()
} timeline: {
    StreakWidgetEntry.default
}

#Preview("Streak Locked Medium", as: .systemMedium) {
    StreakWidget()
} timeline: {
    StreakWidgetEntry(date: .now, isLoggedIn: false, streak: 0, writtenWeekdays: [])
}

#Preview("Streak Locked Small", as: .systemSmall) {
    StreakWidget()
} timeline: {
    StreakWidgetEntry(date: .now, isLoggedIn: false, streak: 0, writtenWeekdays: [])
}

#Preview("Streak 0 Medium", as: .systemMedium) {
    StreakWidget()
} timeline: {
    StreakWidgetEntry(
        date: .now,
        isLoggedIn: true,
        streak: 0,
        writtenWeekdays: [false, false, false, false, false]
    )
}

#Preview("Streak 0 Small", as: .systemSmall) {
    StreakWidget()
} timeline: {
    StreakWidgetEntry(
        date: .now,
        isLoggedIn: true,
        streak: 0,
        writtenWeekdays: [false, false, false, false, false]
    )
}

#Preview("Streak N Small", as: .systemSmall) {
    StreakWidget()
} timeline: {
    StreakWidgetEntry.default
}
