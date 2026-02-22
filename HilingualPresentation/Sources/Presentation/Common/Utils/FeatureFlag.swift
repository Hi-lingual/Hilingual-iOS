//
//  FeatureFlag.swift
//  HilingualPresentation
//
//  Created by 성현주 on 2/17/26.
//

import Foundation
import FirebaseRemoteConfig

/// FeatureFlag를 설정하기 위한 이벤트를 enum으로 명시해주세요
enum FeatureFlag: String, CaseIterable {
    case wordStudyAllowedNicknames = "wordstudy_allowed_nicknames"

    var defaultValue: NSObject {
        switch self {
        case .wordStudyAllowedNicknames:
            return ["value": []] as NSDictionary
        }
    }
}

@MainActor
final class FeatureFlagService {
    static let shared = FeatureFlagService()

    private let remoteConfig: RemoteConfig

    init(remoteConfig: RemoteConfig = RemoteConfig.remoteConfig()) {
        self.remoteConfig = remoteConfig
    }

    func configureDefaults() {
        let defaults = Dictionary(uniqueKeysWithValues: FeatureFlag.allCases.map { ($0.rawValue, $0.defaultValue) })
        remoteConfig.setDefaults(defaults)
    }

    func isEnabled(_ flag: FeatureFlag, nickname: String?) -> Bool {
        switch flag {
        case .wordStudyAllowedNicknames:
            return isNicknameAllowed(nickname)
        }
    }

    // MARK: - Private Methods

    private func isNicknameAllowed(_ nickname: String?) -> Bool {
        guard let nickname, !nickname.isEmpty else { return false }
        return Set(allowedNicknames()).contains(nickname)
    }

    private func allowedNicknames() -> [String] {
        let key = FeatureFlag.wordStudyAllowedNicknames.rawValue

        if let json = remoteConfig[key].jsonValue as? [String: Any],
           let values = json["value"] as? [Any] {
            return values.compactMap { $0 as? String }
        }

        if let json = remoteConfig[key].jsonValue as? [Any] {
            return json.compactMap { $0 as? String }
        }
        return []
    }
}
