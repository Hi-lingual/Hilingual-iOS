//
//  FCMTokenSyncService.swift
//  HilingualPresentation
//
//  Created by 성현주 on 7/21/26.
//

import Combine
import Foundation
import HilingualDomain

public extension Notification.Name {
    static let hilingualSessionDidAuthenticate = Notification.Name("hilingual.session.didAuthenticate")
    static let hilingualSessionDidEnd = Notification.Name("hilingual.session.didEnd")
}

@MainActor
public final class FCMTokenSyncService {

    public static let shared = FCMTokenSyncService()

    // MARK: - State

    private var deviceUseCase: DeviceUseCase?
    private var isSessionAuthenticated = false
    private var syncedToken: String?
    private var syncCancellable: AnyCancellable?

    private init() {}

    // MARK: - Configuration

    public func configure(deviceUseCase: DeviceUseCase) {
        self.deviceUseCase = deviceUseCase

        FCMTokenManager.shared.onTokenUpdated = { token in
            Task { @MainActor in
                FCMTokenSyncService.shared.handleTokenUpdated(token)
            }
        }
    }

    // MARK: - Session State

    public func sessionDidAuthenticate() {
        isSessionAuthenticated = true
        NotificationCenter.default.post(name: .hilingualSessionDidAuthenticate, object: nil)
        syncIfPossible()
    }

    public func sessionDidEnd() {
        isSessionAuthenticated = false
        syncedToken = nil
        syncCancellable = nil
        NotificationCenter.default.post(name: .hilingualSessionDidEnd, object: nil)
    }

    // MARK: - Sync

    private func handleTokenUpdated(_ token: String) {
        guard !token.isEmpty else { return }
        syncIfPossible()
    }

    private func syncIfPossible() {
        guard isSessionAuthenticated,
              let deviceUseCase,
              let token = FCMTokenManager.shared.currentToken,
              !token.isEmpty,
              token != syncedToken
        else { return }

        syncedToken = token

        syncCancellable = deviceUseCase.updateFcmToken(fcmToken: token)
            .sink(
                receiveCompletion: { completion in
                    guard case let .failure(error) = completion else { return }

                    print("[FCMSync] ❌ 토큰 등록 실패: \(error.localizedDescription)")

                    Task { @MainActor in
                        FCMTokenSyncService.shared.invalidateSyncedToken(token)
                    }
                },
                receiveValue: { _ in
                    print("[FCMSync] ✅ 토큰 등록 성공")
                }
            )
    }

    private func invalidateSyncedToken(_ token: String) {
        guard syncedToken == token else { return }
        syncedToken = nil
    }
}
