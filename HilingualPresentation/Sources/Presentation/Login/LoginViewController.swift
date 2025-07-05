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

    // MARK: - Properties

    private let loginview = LoginView()

    // MARK: - Custom Method

    public override func setUI() {
        view.addSubviews(loginview)
    }

    public override func setLayout() {
        loginview.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Bind

    public override func bind(viewModel: LoginViewModel) {
        let input = LoginViewModel.Input(
            loginButtonTapped: loginview.loginButton.publisher(for: .touchUpInside)
        )

        let output = viewModel.transform(input: input)

        output.navigateToHome
            .sink { [weak self] in
                guard let self = self else { return }
                let homeVC = self.diContainer.makeHomeViewController()
                self.navigationController?.pushViewController(homeVC, animated: true)
            }
            .store(in: &cancellables)
    }
}
