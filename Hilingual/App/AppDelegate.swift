//
//  AppDelegate.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import UIKit
import FirebaseCore
import FirebaseMessaging
import UserNotifications
import HilingualData
import HilingualPresentation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var pendingDeeplinkURL: String?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        UIFont.registerPretendardFonts()

//        for key in UserDefaults.standard.dictionaryRepresentation().keys {
//            UserDefaults.standard.removeObject(forKey: key.description)
//        }
        _ = CoreDataStorage.shared

        AppDIContainer.shared.configureFCMTokenSync()

        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        UIApplication.shared.registerForRemoteNotifications()

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

// MARK: - MessagingDelegate
extension AppDelegate: MessagingDelegate {
    nonisolated func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken else { return }
        
        print("[FCM] 토큰 갱신: \(fcmToken)")
        
        Task { @MainActor in
            FCMTokenManager.shared.currentToken = fcmToken
        }
    }
}
extension AppDelegate: UNUserNotificationCenterDelegate {
    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print("🔔 [앱 포그라운드] 푸시 수신!")
        print("📱 제목: \(notification.request.content.title)")
        print("📱 본문: \(notification.request.content.body)")
        print("📱 데이터: \(userInfo)")
        
        completionHandler([.banner, .sound, .badge])
    }

    nonisolated func userNotificationCenter(
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

        Task { @MainActor in
            DeeplinkManager.shared.pendingDestination = destination
        }
        
        completionHandler()
    }
}
