//
//  AppDelegate.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import UIKit
import FirebaseCore
import FirebaseCrashlytics
import HilingualCore
import FirebaseMessaging
import UserNotifications
import HilingualData
import HilingualPresentation

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {
    
    var pendingDeeplinkURL: String?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        // 비치명(non-fatal) API 에러 리포팅은 RELEASE 빌드만. (한 프로젝트·프로젝트 단위 Slack이라 개발 중 에러가 Slack에 도배되는 것 방지 — Android ReleaseTree와 동일)
        // 크래시는 빌드 무관하게 Crashlytics가 자동 수집한다.
        #if !DEBUG
        CrashReporter.reporter = FirebaseCrashReporter()
        #endif
        UIFont.registerPretendardFonts()
        
        //        for key in UserDefaults.standard.dictionaryRepresentation().keys {
        //            UserDefaults.standard.removeObject(forKey: key.description)
        //        }
        _ = CoreDataStorage.shared
        
        AppDIContainer.shared.configureFCMTokenSync()
        AppDIContainer.shared.configureWidgetSync()

        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        UIApplication.shared.registerForRemoteNotifications()
        
        return true
    }
    
    nonisolated func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken else { return }
        
        print("[FCM] 토큰 갱신: \(fcmToken)")
        
        Task { @MainActor in
            FCMTokenManager.shared.currentToken = fcmToken
        }
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

@MainActor
extension AppDelegate: @preconcurrency UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        let userInfo = notification.request.content.userInfo
        print("🔔 [앱 포그라운드] 푸시 수신!")
        print("📱 제목: \(notification.request.content.title)")
        print("📱 본문: \(notification.request.content.body)")
        print("📱 데이터: \(userInfo)")
        
        completionHandler([.banner, .sound, .badge])
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        print("🔔 [푸시 탭됨!]")
        print("📱 전체 데이터: \(userInfo)")
        
        guard let link = userInfo["link"] as? String,
              let url = URL(string: link),
              let destination = DeeplinkParser.parse(url: url) else {
            print("⚠️ link 파싱 실패")
            completionHandler()
            return
        }

        print("[Deeplink] 푸시 탭 → \(destination)")

        let analytics = destination.pushNotificationAnalytics
        AmplitudeManager.shared.send(
            .clickPushNotification(notificationType: analytics.type, page: analytics.page)
        )

        DeeplinkManager.shared.pendingDestination = destination
        completionHandler()
    }
}

// MARK: - CrashReporting (Crashlytics 구현체)

final class FirebaseCrashReporter: CrashReporting {

    func record(_ error: Error, userInfo: [String: String]) {
        let crashlytics = Crashlytics.crashlytics()
        for (key, value) in userInfo {
            crashlytics.setCustomValue(value, forKey: key)
        }
        crashlytics.record(error: error)
    }

    func log(_ message: String) {
        Crashlytics.crashlytics().log(message)
    }
}
