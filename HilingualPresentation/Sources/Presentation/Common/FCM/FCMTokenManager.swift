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
    private nonisolated(unsafe) var _currentToken: String?
    public nonisolated(unsafe) var onTokenUpdated: ((String) -> Void)?
    
    public var currentToken: String? {
        get {
            lock.withLock { _currentToken }
        }
        set {
            lock.withLock { _currentToken = newValue }
            guard let token = newValue, !token.isEmpty else { return }
            onTokenUpdated?(token)
        }
    }
}
