//
//  AmplitudeManager.swift
//  HilingualPresentation
//
//  Created by 성현주 on 10/26/25.
//

import AmplitudeSwift
import UIKit

@MainActor
public final class AmplitudeManager: @unchecked Sendable {

    // MARK: - Singleton
    public static let shared = AmplitudeManager()

    // MARK: - Properties
    private var amplitude: Amplitude?
    private var isInitialized = false

    // MARK: - Initialization
    private init() {}

    // MARK: - Setup
    public func initialize(apiKey: String) {
        guard !isInitialized else {
            print("[Amplitude] Already initialized")
            return
        }

        let configuration = Configuration(apiKey: apiKey)
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
        print("[Amplitude] Initialized in DEBUG mode")
        print("[Amplitude] API Key: \(apiKey.prefix(10))...")
        print("[Amplitude] Log Level: DEBUG")
        print("[Amplitude] Auto Sessions: \(configuration.defaultTracking.sessions)")
        print("[Amplitude] Auto Screen Views: \(configuration.defaultTracking.screenViews)")
        #else
        print("[Amplitude] Initialized in RELEASE mode")
        #endif
    }

    // MARK: - Event Tracking
    public func logEvent(_ eventName: String, properties: [String: Any]? = nil) {
        guard isInitialized else {
            print("[Amplitude] Not initialized. Call initialize() first.")
            return
        }

        #if DEBUG
        print("[Amplitude] Event: \(eventName)")
        if let properties = properties, !properties.isEmpty {
            print("[Amplitude] Properties:")
            for (key, value) in properties.sorted(by: { $0.key < $1.key }) {
                print("[Amplitude]   \(key): \(value)")
            }
        }
        print("[Amplitude] Timestamp: \(Date())")
        #endif

        amplitude?.track(eventType: eventName, eventProperties: properties)
    }

    // MARK: - User Management
    public func setUserId(_ userId: String?) {
        guard isInitialized else {
            print("[Amplitude] Not initialized. Call initialize() first.")
            return
        }

        #if DEBUG
        print("[Amplitude] Set User ID: \(userId ?? "nil")")
        #endif

        amplitude?.setUserId(userId: userId)
    }

    public func setUserProperty(key: String, value: Any) {
        guard isInitialized else {
            print("[Amplitude] Not initialized. Call initialize() first.")
            return
        }

        #if DEBUG
        print("[Amplitude] User Property: \(key) = \(value)")
        #endif

        let identify = Identify()
        identify.set(property: key, value: value)
        amplitude?.identify(identify: identify)
    }

    public func setUserProperties(_ properties: [String: Any]) {
        guard isInitialized else {
            print("[Amplitude] Not initialized. Call initialize() first.")
            return
        }

        #if DEBUG
        print("[Amplitude] Setting multiple user properties:")
        for (key, value) in properties.sorted(by: { $0.key < $1.key }) {
            print("[Amplitude]   \(key): \(value)")
        }
        #endif

        let identify = Identify()
        for (key, value) in properties {
            identify.set(property: key, value: value)
        }
        amplitude?.identify(identify: identify)
    }

    // MARK: - Session Management
    public func reset() {
        guard isInitialized else {
            print("[Amplitude] Not initialized. Call initialize() first.")
            return
        }

        #if DEBUG
        print("[Amplitude] Resetting session and user data")
        #endif

        amplitude?.reset()
    }

    // MARK: - Revenue Tracking
    public func logRevenue(productId: String, quantity: Int = 1, price: Double) {
        guard isInitialized else {
            print("[Amplitude] Not initialized. Call initialize() first.")
            return
        }

        #if DEBUG
        print("[Amplitude] Revenue Event")
        print("[Amplitude]   Product ID: \(productId)")
        print("[Amplitude]   Quantity: \(quantity)")
        print("[Amplitude]   Price: \(price)")
        print("[Amplitude]   Total: \(Double(quantity) * price)")
        #endif

        let revenue = Revenue()
        revenue.productId = productId
        revenue.quantity = quantity
        revenue.price = price
        amplitude?.revenue(revenue: revenue)
    }
}
