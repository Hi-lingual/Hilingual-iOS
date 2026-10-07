//
//  FCMTokenManager.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 5/16/26.
//

import Foundation

public final class FCMTokenManager: Sendable {
    public static let shared = FCMTokenManager()
    private init() {}
    
    private let lock = NSLock()
    private nonisolated(unsafe) var currentToken: String?
    public nonisolated(unsafe) var onTokenUpdated: ((String) -> Void)?
    
    public var token: String? {
        get {
            lock.withLock { currentToken }
        }
        set {
            lock.withLock { currentToken = newValue }
            guard let token = newValue, !token.isEmpty else { return }
            onTokenUpdated?(token)
        }
    }
}
