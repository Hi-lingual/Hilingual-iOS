//
//  SplashViewController.swift
//  HilingualPresentation
//
//  Created by 성현주 on 7/15/25.
//

import UIKit
import Combine

public final class SplashViewController: BaseUIViewController<SplashViewModel> {

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        
        let output = viewModel?.transform(input: .init(
            viewDidLoad: Just(()).eraseToAnyPublisher()
        ))

        output?.navigateToHome
            .sink { [weak self] in
                guard let self else { return }
                print("스플래시 -> 홈")
                let vc = self.diContainer.makeTabBarViewController()
                changeRootVC(vc)
            }
            .store(in: &cancellables)

        output?.navigateToOnboarding
            .sink { [weak self] in
                guard let self else { return }
                print("스플래시 -> 온보딩")
                let vc = self.diContainer.makeOnboardingViewController()
                changeRootVC(vc)
            }
            .store(in: &cancellables)

        output?.navigateToLogin
            .sink { [weak self] in
                guard let self else { return }
                print("스플래시 -> 로그인")
                let vc = self.diContainer.makeLoginViewController()
                changeRootVC(vc)
            }
            .store(in: &cancellables)
    }
}
