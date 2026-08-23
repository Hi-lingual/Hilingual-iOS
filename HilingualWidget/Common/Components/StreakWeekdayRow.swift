//
//  StreakWeekdayRow.swift
//  HilingualWidget
//
//  Created by youngseo on 8/22/26.
//

import SwiftUI
import WidgetKit

// MARK: - View

struct StreakWeekdayRow: View {
    let recentDays: [StreakWidgetRecentDay]
    let isLoggedIn: Bool

    var body: some View {
        HStack(spacing: 6) {
            ForEach(Array(recentDays.enumerated()), id: \.offset) { _, day in
                StreakWeekdayChip(
                    title: day.weekdayText,
                    isWritten: day.isWritten,
                    isLoggedIn: isLoggedIn
                )
            }
        }
    }
}

// MARK: - Components

private struct StreakWeekdayChip: View {
    private enum State {
        case locked
        case written
        case unwritten
    }

    @Environment(\.colorScheme) private var colorScheme

    let title: String
    let isWritten: Bool
    let isLoggedIn: Bool

    var body: some View {
        ZStack {
            Image(imageResource)
                .resizable()
                .scaledToFit()

            if state != .locked {
                Text(title)
                    .font(.pretendard(.body_m_12))
                    .foregroundStyle(textColor)
                    .padding(.horizontal, 7.5)
                    .padding(.vertical, 6)
            }
        }
        .frame(width: 26, height: 26)
    }

    private var state: State {
        if !isLoggedIn {
            return .locked
        }
        return isWritten ? .written : .unwritten
    }

    private var imageResource: ImageResource {
        switch state {
        case .locked:
            return colorScheme == .dark ? .chipWidgetdateLockedGray : .chipWidgetdateLockedLightgray
        case .written:
            return .chipWidgetdateWrittenOrange
        case .unwritten:
            return colorScheme == .dark ? .chipWidgetdateUnwrittenGray : .chipWidgetdateUnwrittenLightgray
        }
    }

    private var textColor: Color {
        if colorScheme == .dark {
            return .white
        }
        return state == .written ? .white : .gray500
    }
}
