//
//  SceneDelegate.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import UIKit
import HilingualPresentation
import HilingualCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        if let apiKey = Bundle.main.infoDictionary?["AMPLITUDE_API_KEY"] as? String {
            AmplitudeManager.shared.initialize(apiKey: apiKey)
        } else {
            print("[Amplitude] API Key not found in Info.plist")
        }

        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        window.backgroundColor = .white
        self.window = window

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

    // MARK: - Scene Lifecycle (기본 제공 메서드)

    func sceneDidBecomeActive(_ scene: UIScene) { }
    func sceneWillResignActive(_ scene: UIScene) { }
    func sceneWillEnterForeground(_ scene: UIScene) { }
    func sceneDidEnterBackground(_ scene: UIScene) { }
}
