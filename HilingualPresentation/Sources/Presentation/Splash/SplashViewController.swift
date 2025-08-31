//
//  SplashViewController.swift
//  HilingualPresentation
//
//  Created by 성현주 on 7/15/25.
//

import Combine
import UIKit

public final class SplashViewController: BaseUIViewController<SplashViewModel> {

    // MARK: - UI

    private let splashView = SplashView()

    // MARK: - Combine

    private let viewDidAppearSubject = PassthroughSubject<Void, Never>()

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
        viewDidAppearSubject.send(())
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

                let loginVC = self.diContainer.makeLoginViewController()
                let verificationVC = self.diContainer.makeVerificationCodeViewController()

                let nav = UINavigationController()
                nav.setViewControllers([loginVC, verificationVC], animated: false)

                changeRootVC(nav, animated: true)
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
