//
//  VerificationCodeViewController.swift
//  HilingualPresentation
//
//  Created by 성현주 on 8/12/25.
//

import Foundation
import Combine

public final class VerificationCodeViewController: BaseUIViewController<VerificationCodeViewModel> {

    // MARK: - Properties

    private let verificationCodeView = VerificationCodeView()

    // MARK: - Custom Method

    public override func setUI() {
        view.addSubviews(verificationCodeView)
    }

    public override func setLayout() {
        verificationCodeView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    // MARK: - Navigation

    public override func navigationType() -> NavigationType? {
        .backTitleMenu("인증코드 입력")
    }

    // MARK: - Bind

    public override func bind(viewModel: VerificationCodeViewModel) {
        let output = viewModel.transform()

        output.errorMessage
            .sink { [weak self] message in
                if let msg = message {
                    self?.verificationCodeView.codeView.setState(.error(msg))
                } else {
                    self?.verificationCodeView.codeView.setState(.normal)
                }
            }
            .store(in: &cancellables)

        output.isSubmitEnabled
            .assign(to: \.isEnabled, on: verificationCodeView.submitButton)
            .store(in: &cancellables)

        output.didVerifySuccess
            .sink { [weak self] in
                guard let self else { return }
                let onboardingVC = diContainer.makeOnboardingViewController()
                self.navigationController?.pushViewController(onboardingVC, animated: true)
            }
            .store(in: &cancellables)

        verificationCodeView.codeView.onTextChanged = { [weak self] text in
            self?.viewModel?.updateCode(text)
        }

        verificationCodeView.submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
    }

    // MARK: - Action

    @objc private func submitTapped() {
        let code = verificationCodeView.codeView.text
        viewModel?.submit(code: code)
    }
}
