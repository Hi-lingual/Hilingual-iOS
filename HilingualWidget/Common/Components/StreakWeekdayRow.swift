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
    let writtenWeekdays: [Bool]
    let isLoggedIn: Bool

    var body: some View {
        HStack(spacing: 6) {
            ForEach(Self.weekdayLabels.indices, id: \.self) { index in
                StreakWeekdayChip(
                    title: Self.weekdayLabels[index],
                    isWritten: writtenWeekdays[safe: index] ?? false,
                    isLoggedIn: isLoggedIn
                )
            }
        }
    }

    private static let weekdayLabels = ["월", "화", "수", "목", "금"]
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
            Image(imageName)
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

    private var imageName: String {
        switch state {
        case .locked:
            return colorScheme == .dark ? "chip_widgetdate_locked_gray" : "chip_widgetdate_locked_lightgray"
        case .written:
            return "chip_widgetdate_written_orange"
        case .unwritten:
            return colorScheme == .dark ? "chip_widgetdate_unwritten_gray" : "chip_widgetdate_unwritten_lightgray"
        }
    }

    private var textColor: Color {
        state == .written ? .white : .gray500
    }
}

// MARK: - Extensions

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
