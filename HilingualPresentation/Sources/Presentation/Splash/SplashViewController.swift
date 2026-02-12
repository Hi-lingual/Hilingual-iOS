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
    private let remoteConfig = RemoteConfig.remoteConfig()

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
            "minimum_version_iOS": "1.0.0" as NSObject,
            "latestVersion": "1.0.0" as NSObject,
            "update_title": "새로운 버전이 업데이트 되었어요!" as NSObject,
            "update_message": "안정적인 서비스 사용을 위해 \n최신 버전으로 업데이트 해주세요." as NSObject,
            "update_link": "https://apps.apple.com/kr/app/id6752608763" as NSObject
        ]
        remoteConfig.setDefaults(defaults)

        remoteConfig.fetch(withExpirationDuration: 0) { [weak self] _, error in
            Task { @MainActor in
                guard let self else { return }

                if let error {
                    print("🔥 RemoteConfig fetch 실패: \(error.localizedDescription)")
                    self.viewDidAppearSubject.send(())
                    return
                }

                self.activateRemoteConfigAndEvaluate()
            }
        }
    }

    @MainActor
    private func activateRemoteConfigAndEvaluate() {
        remoteConfig.activate { [weak self] _, error in
            Task { @MainActor in
                guard let self else { return }

                if let error {
                    print("🔥 RemoteConfig activate 실패: \(error.localizedDescription)")
                    self.viewDidAppearSubject.send(())
                    return
                }

                self.evaluateVersion()
            }
        }
    }

    @MainActor
    private func evaluateVersion() {
        let minimumVersion = remoteConfig["minimum_version_iOS"].stringValue
        let latestVersion = remoteConfig["latestVersion"].stringValue
        let title = remoteConfig["update_title"].stringValue
        let message = remoteConfig["update_message"].stringValue
        let link = remoteConfig["update_link"].stringValue

        guard let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            print("현재 버전 정보를 가져오지 못했습니다.")
            viewDidAppearSubject.send(())
            return
        }

        print("현재 버전: \(currentVersion)")
        print("최소 지원 버전: \(minimumVersion)")
        print("최신 버전: \(latestVersion)")

        if currentVersion.compare(minimumVersion, options: .numeric) == .orderedAscending {
            showUpdateAlert(title: title, message: message, link: link, isForce: true)
        } else if currentVersion.compare(latestVersion, options: .numeric) == .orderedAscending {
            showUpdateAlert(title: title, message: message, link: link, isForce: false)
        } else {
            viewDidAppearSubject.send(())
        }
    }

    @MainActor
    private func showUpdateAlert(title: String, message: String, link: String, isForce: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let updateAction = UIAlertAction(title: "업데이트 하러가기", style: .default) { _ in
            guard let url = URL(string: link), UIApplication.shared.canOpenURL(url) else { return }
            UIApplication.shared.open(url)
        }
        alert.addAction(updateAction)

        if !isForce {
            alert.addAction(UIAlertAction(title: "나중에", style: .cancel) { [weak self] _ in
                self?.viewDidAppearSubject.send(())
            })
        }

        present(alert, animated: true)
    }

    // MARK: - Bind

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

        output.navigateToLoginOnBoarding
            .sink { [weak self] in
                guard let self else { return }
                print("스플래시 -> 로그인 온보딩")
                let vc = self.diContainer.makeLoginOnBoardingViewController()
                changeRootVC(vc, animated: true)
            }
            .store(in: &cancellables)
    }
}
