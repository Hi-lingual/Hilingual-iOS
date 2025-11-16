//
//  SplashViewController.swift
//  HilingualPresentation
//
//  Created by 성현주 on 7/15/25.
//

import Combine
import UIKit
import FirebaseCore
import FirebaseRemoteConfig

public final class SplashViewController: BaseUIViewController<SplashViewModel> {

    // MARK: - UI

    private let splashView = SplashView()

    // MARK: - Combine

    private let viewDidAppearSubject = PassthroughSubject<Void, Never>()

    // MARK: - Firebase Remote Config

    private var remoteConfig = RemoteConfig.remoteConfig()

    // MARK: - Lifecycle

    public override func setUI() {
        view.addSubviews(splashView)
    }

    public override func setLayout() {
        splashView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkRemoteConfigVersion()
    }

    // MARK: - Remote Config Check

    private func checkRemoteConfigVersion() {
        let defaults: [String: NSObject] = [
            "minimumVersion": "1.0.0" as NSObject,
            "latestVersion": "1.0.0" as NSObject,
            "update_title": "업데이트 안내" as NSObject,
            "update_message": "최신 버전으로 업데이트 해주세요." as NSObject,
            "update_link": "https://apps.apple.com/kr/app/id6752608763" as NSObject
        ]
        remoteConfig.setDefaults(defaults)

        // fetch
        remoteConfig.fetch(withExpirationDuration: 0) { [weak self] status, error in
            guard let self = self else { return }

            if let error = error {
                print("🔥 RemoteConfig fetch 실패: \(error.localizedDescription)")
                self.viewDidAppearSubject.send(())
                return
            }

            self.remoteConfig.activate { _, _ in
                self.evaluateVersion()
            }
        }
    }

    private func evaluateVersion() {
        let minimumVersion = remoteConfig["minimum_version_iOS"].stringValue ?? "1.0.0"
        let latestVersion = remoteConfig["latestVersion"].stringValue ?? "1.0.0"
        let title = remoteConfig["update_title"].stringValue ?? "업데이트 안내"
        let message = remoteConfig["update_message"].stringValue ?? "최신 버전으로 업데이트 해주세요."
        let link = remoteConfig["update_link"].stringValue ?? ""

        guard let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            print("현재 버전 정보를 가져오지 못했습니다.")
            viewDidAppearSubject.send(())
            return
        }

        print("현재 버전: \(currentVersion)")
        print("최소 지원 버전: \(minimumVersion)")
        print("최신 버전: \(latestVersion)")

        // 강제 업데이트 조건 (현재 버전 < minimumVersion)
        if currentVersion.compare(minimumVersion, options: .numeric) == .orderedAscending {
            DispatchQueue.main.async {
                self.showUpdateAlert(title: title, message: message, link: link, isForce: true)
            }
        }
        // 선택 업데이트 조건 (현재 버전 < latestVersion)
        else if currentVersion.compare(latestVersion, options: .numeric) == .orderedAscending {
            DispatchQueue.main.async {
                self.showUpdateAlert(title: title, message: message, link: link, isForce: false)
            }
        }
        // 최신 버전이면 로그인 로직 진행
        else {
            DispatchQueue.main.async {
                self.viewDidAppearSubject.send(())
            }
        }
    }

    private func showUpdateAlert(title: String, message: String, link: String, isForce: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let updateAction = UIAlertAction(title: "업데이트", style: .default) { _ in
            if let url = URL(string: link), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
        alert.addAction(updateAction)

        // 선택 업데이트만 '나중에' 버튼 표시
        if !isForce {
            alert.addAction(UIAlertAction(title: "나중에", style: .cancel) { [weak self] _ in
                self?.viewDidAppearSubject.send(()) // 로그인 진행
            })
        }

        present(alert, animated: true)
    }

    // MARK: - ViewModel 바인딩

    public override func bind(viewModel: SplashViewModel) {
        let output = viewModel.transform(input: .init(
            viewDidLoad: viewDidAppearSubject.eraseToAnyPublisher()
        ))

        output.navigateToHome
            .sink { [weak self] in
                guard let self else { return }
                print("스플래시 -> 홈")
                let vc = self.diContainer.makeTabBarViewController()
                changeRootVC(vc, animated: true)
            }
            .store(in: &cancellables)

        output.navigateToOnboarding
            .sink { [weak self] in
                guard let self else { return }
                print("스플래시 → 온보딩(로그인 → 인증코드)")
                let verificationVC = self.diContainer.makeOnboardingViewController()

                changeRootVC(verificationVC, animated: true)
            }
            .store(in: &cancellables)

        output.navigateToLogin
            .sink { [weak self] in
                guard let self else { return }
                print("스플래시 -> 로그인")
                let vc = self.diContainer.makeLoginViewController()
                let nav = UINavigationController(rootViewController: vc)
                changeRootVC(nav, animated: true)
            }
            .store(in: &cancellables)
    }
}
