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
import HilingualData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

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

//
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
