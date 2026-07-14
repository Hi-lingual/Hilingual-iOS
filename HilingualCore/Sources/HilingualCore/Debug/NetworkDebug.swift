//
//  NetworkDebug.swift
//  HilingualCore
//
//  Created by 성현주 on 6/27/26.
//

import Foundation

#if DEBUG
public enum NetworkDebug {

    nonisolated(unsafe) public static var forcedErrors: [String: HilingualError] = [:]

    nonisolated(unsafe) public static var maxFailCount = 1

    nonisolated(unsafe) private static var failCounts: [String: Int] = [:]

    public static func forcedError(for path: String) -> HilingualError? {
        guard let key = forcedErrors.keys.first(where: { path.contains($0) }) else { return nil }
        let used = failCounts[key, default: 0]
        guard used < maxFailCount else { return nil }
        failCounts[key] = used + 1
        return forcedErrors[key]
    }

    public static func resetFailCounts() {
        failCounts.removeAll()
    }

    // MARK: - 디버그 화면용 테스트 케이스 카탈로그

    public struct TestCase: Sendable {
        public let label: String
        public let path: String
        public init(label: String, path: String) {
            self.label = label
            self.path = path
        }
    }

    public static let testCases: [TestCase] = [
        .init(label: "홈", path: "/v2/users/home/info"),
        .init(label: "단어장", path: "/v1/voca"),
        .init(label: "피드(추천)", path: "/v1/feed/recommend"),
        .init(label: "마이", path: "/v1/users/mypage/info"),
        .init(label: "타유저 프로필", path: "/v1/feed/profiles/"),
        .init(label: "일기 상세(피드백)", path: "/feedbacks"),
        .init(label: "팔로워 목록", path: "/followers"),
        .init(label: "좋아요", path: "/v1/feed/likes/"),
        .init(label: "게시", path: "/publish"),
        .init(label: "비공개", path: "/unpublish")
    ]
}
#endif
