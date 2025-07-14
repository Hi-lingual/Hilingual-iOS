//
//  LoginViewController.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Foundation
import Combine

public final class LoginViewController: BaseUIViewController<LoginViewModel> {

    // MARK: - Properties

    private let loginView = LoginView()

    //MARK: - Life cycle

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loginView.startSplashAnimation()
    }

    // MARK: - Custom Layout

    public override func setUI() {
        view.addSubviews(loginView)
    }

    public override func setLayout() {
        loginView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Navigation

    public override func navigationType() -> NavigationType? {
        return nil
    }

    // MARK: - Bind

    public override func bind(viewModel: LoginViewModel) {
        super.bind(viewModel: viewModel)

        let input = makeInput()
        let output = viewModel.transform(input: input)

        bindOutput(output)
    }

    private func makeInput() -> LoginViewModel.Input {
        return LoginViewModel.Input(
            loginTapped: loginView.appleLoginButton.publisher(for: .touchUpInside)
        )
    }

    private func bindOutput(_ output: LoginViewModel.Output) {
        output.navigateToHome
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let self else { return }
                print("로그인 -> 홈")
                let homeVC = self.diContainer.makeTabBarViewController()
                changeRootVC(homeVC)
            }
            .store(in: &cancellables)

        output.navigateToOnboarding
            .sink { [weak self] in
                guard let self else { return }
                print("로그인 -> 온보딩")
                let onboardingVC = self.diContainer.makeOnboardingViewController()
                changeRootVC(onboardingVC)
            }
            .store(in: &cancellables)


        output.error
            .receive(on: RunLoop.main)
            .sink { error in
                print("로그인 중 에러 발생: \(error)")
                // TODO: Alert 또는 Toast 처리
            }
            .store(in: &cancellables)
    }
}
