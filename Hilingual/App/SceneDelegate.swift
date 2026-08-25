//
//  SceneDelegate.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Combine
import UIKit
import HilingualPresentation
import HilingualCore
import HilingualNetwork

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private var cancellables = Set<AnyCancellable>()

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        if let apiKey = Bundle.main.infoDictionary?["AMPLITUDE_API_KEY"] as? String {
            AmplitudeManager.shared.initialize(apiKey: apiKey)
        } else {
            print("[Amplitude] API Key not found in Info.plist")
        }

        Task { @MainActor in
            EnglishPronunciationPlayer.shared.prepare()
        }

        if let response = connectionOptions.notificationResponse {
            let userInfo = response.notification.request.content.userInfo
            if let link = userInfo["link"] as? String,
               let url = URL(string: link),
               let destination = DeeplinkParser.parse(url: url) {
                let analytics = destination.pushNotificationAnalytics
                AmplitudeManager.shared.send(
                    .clickPushNotification(notificationType: analytics.type, page: analytics.page)
                )
                DeeplinkManager.shared.pendingDestination = destination
            }
        }

        if let url = connectionOptions.urlContexts.first?.url {
            handleDeepLink(url)
        }

        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        window.backgroundColor = .white
        self.window = window

        observeSessionExpired()

        // Step 1: Launch 화면 표시
        let launchScreenVC = LaunchScreen()
        window.rootViewController = launchScreenVC
        window.makeKeyAndVisible()

        // Step 2: 0.7초 후 SplashViewController로 전환
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            let appDI = AppDIContainer.shared
            let splashVC = appDI.makeSplashViewController()
            let navigation = UINavigationController(rootViewController: splashVC)
            navigation.setNavigationBarHidden(true, animated: false)

            UIView.transition(with: window,
                              duration: 0.5,
                              options: [.transitionCrossDissolve],
                              animations: {
                window.rootViewController = navigation
            })
        }
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        handleDeepLink(url)
    }

    @MainActor
    private func handleDeepLink(_ url: URL) {
        guard let destination = DeeplinkParser.parse(url: url) else { return }

        if let widgetType = widgetType(from: url) {
            AmplitudeManager.shared.send(.clickWidget(widgetType: widgetType))
        }

        DeeplinkManager.shared.pendingDestination = destination
    }

    private func widgetType(from url: URL) -> AnalyticsEvent.WidgetType? {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let widgetType = components?.queryItems?.first {
            $0.name.lowercased() == "widget_type"
        }?.value

        return AnalyticsEvent.WidgetType.from(widgetType)
    }

    // MARK: - Session Expired

    private func observeSessionExpired() {
        NotificationCenter.default.publisher(for: .sessionExpired)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.routeToLogin()
            }
            .store(in: &cancellables)
    }

    private func routeToLogin() {
        guard let window else { return }

        FCMTokenSyncService.shared.sessionDidEnd()

        let loginVC = AppDIContainer.shared.makeLoginViewController()
        let navigation = UINavigationController(rootViewController: loginVC)

        UIView.transition(with: window,
                          duration: 0.4,
                          options: [.transitionCrossDissolve],
                          animations: {
            window.rootViewController = navigation
        })
    }

    // MARK: - Scene Lifecycle (기본 제공 메서드)

    func sceneDidBecomeActive(_ scene: UIScene) {
        WidgetSyncService.shared.syncTodayWidgets()
        WidgetSyncService.shared.syncWidgetCountAnalytics()
    }
    func sceneWillResignActive(_ scene: UIScene) { }
    func sceneWillEnterForeground(_ scene: UIScene) { }
    func sceneDidEnterBackground(_ scene: UIScene) { }
}
