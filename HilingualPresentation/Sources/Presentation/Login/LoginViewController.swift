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

    private let mainView = LoginView()

    public override func loadView() {
        self.view = mainView
    }

    public override func bind(viewModel: LoginViewModel) {
        let input = LoginViewModel.Input(
            loginButtonTapped: mainView.loginButton.publisher(for: .touchUpInside)
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
