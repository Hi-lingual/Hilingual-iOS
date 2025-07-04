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

    private let mainView = LoginView()
    private let diContainer: DIContainer

    // MARK: - Init

    public init(viewModel: LoginViewModel, diContainer: DIContainer) {
        self.diContainer = diContainer
        super.init(viewModel: viewModel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func loadView() {
        self.view = mainView
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
            loginButtonTapped: mainView.loginButton.publisher(for: .touchUpInside)
        )
    }

    private func bindOutput(_ output: LoginViewModel.Output) {
        output.navigateToHome
            .sink { [weak self] in
                guard let self = self else { return }
                let homeVC = self.diContainer.makeHomeViewController()
                self.navigationController?.pushViewController(homeVC, animated: true)
            }
            .store(in: &cancellables)
    }
}
