//
//  AmplitudeManager.swift
//  HilingualCore
//

import AmplitudeSwift
import Foundation

@MainActor
public final class AmplitudeManager: @unchecked Sendable {

    // MARK: - Singleton
    public static let shared = AmplitudeManager()

    // MARK: - Properties
    private var amplitude: Amplitude?
    private var isInitialized = false

    // MARK: - Initialization
    private init() {}

    // MARK: - Validation
    @inline(__always)
    private func ensureInitialized() -> Bool {
        guard isInitialized else {
            #if DEBUG
            print("[Amplitude] Not initialized. Call initialize() first.")
            #endif
            return false
        }
        return true
    }

    // MARK: - Setup
    public func initialize(apiKey: String) {
        guard !isInitialized else {
            #if DEBUG
            print("[Amplitude] Already initialized")
            #endif
            return
        }

        let configuration = Configuration(apiKey: apiKey, minIdLength: 1)
        configuration.defaultTracking.sessions = true
        configuration.defaultTracking.screenViews = true

        #if DEBUG
        configuration.logLevel = .DEBUG
        #else
        configuration.logLevel = .WARN
        #endif

        amplitude = Amplitude(configuration: configuration)
        isInitialized = true

        #if DEBUG
        print("[Amplitude] Initialized")
        #endif
    }

    // MARK: - Event Tracking
    public func send(_ event: AnalyticsEvent) {
        logSendAttempt(event)
        logEvent(event.name, properties: event.properties)
    }

    // MARK: - User Management
    public func sendUserProperty(key: String, value: Any) {
        setUserProperty(key: key, value: value)
    }

    public func sendUserProperty(_ properties: [String: Any]) {
        setUserProperties(properties)
    }

    public func setUserId(_ userId: String?) {
        guard ensureInitialized() else {
            #if DEBUG
            print("[Amplitude] ⚠️ setUserId 무시됨 — 미초기화 (userId: \(String(describing: userId)))")
            #endif
            return
        }

        amplitude?.setUserId(userId: userId)
        #if DEBUG
        print("[Amplitude] ✅ setUserId = \(String(describing: userId))")
        #endif
    }

    /// 서버 userId(Long)를 Amplitude userId로 설정한다.
    public func updateUserId(_ userId: Int64) {
        #if DEBUG
        print("[Amplitude] 📥 updateUserId(\(userId)) 호출됨")
        #endif
        setUserId(String(userId))
    }

    /// 로그아웃/탈퇴 시 userId를 해제한다.
    public func clearUserId() {
        setUserId(nil)
    }

    public func setUserProperty(key: String, value: Any) {
        guard ensureInitialized() else { return }

        let identify = Identify()
        identify.set(property: key, value: value)
        amplitude?.identify(identify: identify)
    }

    public func setUserProperties(_ properties: [String: Any]) {
        guard ensureInitialized() else { return }

        let identify = Identify()
        for (key, value) in properties {
            identify.set(property: key, value: value)
        }
        amplitude?.identify(identify: identify)
    }

    // MARK: - Private
    private func logEvent(_ eventName: String, properties: [String: Any]? = nil) {
        guard ensureInitialized() else { return }

        amplitude?.track(eventType: eventName, eventProperties: properties)
    }

    private func logSendAttempt(_ event: AnalyticsEvent) {
        print("[Amplitude] Send: \(event.name) | case: \(event.caseDescription) | properties: \(String(describing: event.properties)) | initialized: \(isInitialized)")
    }
}
