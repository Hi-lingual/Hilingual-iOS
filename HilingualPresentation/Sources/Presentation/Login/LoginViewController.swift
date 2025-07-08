//
//  LoginViewController.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Foundation
import UIKit
import Combine

public final class LoginViewController: BaseUIViewController<LoginViewModel> {

    private let loginview = LoginView()
    private let nicknameSubject = PassthroughSubject<String, Never>()

    public override func setUI() {
        view.addSubviews(loginview)
    }

    public override func setLayout() {
        loginview.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    public override func bind(viewModel: LoginViewModel) {
        loginview.customTextfield.textField.addTarget(
            self,
            action: #selector(nicknameDidChange),
            for: .editingChanged
        )

        let input = LoginViewModel.Input(
            loginButtonTapped: loginview.loginButton.publisher(for: .touchUpInside),
            nicknameChanged: nicknameSubject.eraseToAnyPublisher()
        )

        let output = viewModel.transform(input: input)

        output.navigateToHome
            .sink { [weak self] in
                guard let self = self else { return }
                let homeVC = self.diContainer.makeHomeViewController()
                self.navigationController?.pushViewController(homeVC, animated: true)
            }
            .store(in: &cancellables)

        output.nicknameState
            .sink { [weak self] state in
                self?.loginview.customTextfield.updateState(state)
            }
            .store(in: &cancellables)
    }

    @objc private func nicknameDidChange() {
        nicknameSubject.send(loginview.customTextfield.text)
    }
}
