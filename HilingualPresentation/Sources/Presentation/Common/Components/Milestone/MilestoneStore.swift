//
//  MilestoneStore.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 10/18/26.
//

@MainActor
final class MilestoneStore {
    static let shared = MilestoneStore()
    private init() {}

    private var pendingCount: Int?

    func setPending(_ count: Int) {
        pendingCount = MilestoneStyle(count: count) != nil ? count : nil
    }

    var hasPending: Bool { pendingCount != nil }

    func consume() -> Int? {
        defer { pendingCount = nil }
        return pendingCount
    }
}
