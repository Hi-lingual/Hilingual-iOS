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

    // MARK: - Navigation 설정 (필요 시)

    public override func navigationType() -> NavigationType? {
        return nil  // 로그인 화면은 일반적으로 뒤로가기 없음
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

                // TODO: 서버 API 호출 또는 화면 전환 -> 임시 
                let homeVC = self.diContainer.makeTabBarViewController()
                changeRootVC(homeVC, animated: false)
            }
            .store(in: &cancellables)
    }
}
