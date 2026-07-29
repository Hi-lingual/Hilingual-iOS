//
//  FCMTokenManager.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 5/16/26.
//

public final class FCMTokenManager: Sendable {
    public static let shared = FCMTokenManager()
    private init() {}

    public nonisolated(unsafe) var onTokenUpdated: ((String) -> Void)?

    public nonisolated(unsafe) var currentToken: String? {
        didSet {
            guard let token = currentToken, !token.isEmpty else { return }
            onTokenUpdated?(token)
        }
    }
}
