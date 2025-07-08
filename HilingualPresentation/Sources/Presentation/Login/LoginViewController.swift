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

    // MARK: - UI 설정

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
        output.loginResult
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("로그인 실패: \(error)")
                    // TODO: 에러 토스트 또는 Alert
                }
            } receiveValue: { identityToken, userId in
                print("Apple 로그인 성공")
                print("identityToken: \(identityToken)")
                print("userId: \(userId)")

                // TODO: 서버 API 호출 또는 화면 전환 + 분기 처리 -> 임시
                /// 기존 유저라면, 텝바 신규 유저면 로그인
                let onBoardingVC = self.diContainer.makeOnboardingViewController()
                self.navigationController?.pushViewController(onBoardingVC, animated: true)
            }
            .store(in: &cancellables)
    }
}
