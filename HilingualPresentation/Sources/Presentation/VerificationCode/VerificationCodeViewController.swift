//
//  VerificationCodeViewController.swift
//  HilingualPresentation
//
//  Created by 성현주 on 8/12/25.
//

import Foundation
import Combine
import SafariServices

public final class VerificationCodeViewController: BaseUIViewController<VerificationCodeViewModel> {

    // MARK: - Properties

    private let verificationCodeView = VerificationCodeView()
    private let dialog = Dialog()

    // MARK: - Custom Method

    public override func setUI() {
        view.addSubviews(verificationCodeView, dialog)
        verificationCodeView.codeView.becomeFirstResponder()
    }

    public override func setLayout() {
        verificationCodeView.snp.makeConstraints { $0.edges.equalToSuperview() }
        dialog.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    // MARK: - Navigation

    public override func navigationType() -> NavigationType? {
        .titleOnly("인증 번호 입력")
    }

    // MARK: - Bind

    public override func bind(viewModel: VerificationCodeViewModel) {
        let output = viewModel.transform()

        output.errorMessage
            .sink { [weak self] message in
                guard let self else { return }
                if let msg = message {
                    self.verificationCodeView.codeView.setState(.error(msg))
                } else {
                    self.verificationCodeView.codeView.setState(.normal)
                }
            }
            .store(in: &cancellables)

        output.showLockout
            .sink { [weak self] in
                guard let self else { return }
                self.dialog.configure(
                    style: .normal,
                    title: "인증에 실패했어요",
                    content: "사전 예약 알림신청을 통해 발급한\n인증코드가 맞는지 다시 한번 확인해주세요.",
                    leftButtonTitle: "앱 종료",
                    rightButtonTitle: "문의하기",
                    leftAction: { [weak self] in self?.exitApp() },
                    rightAction: { [weak self] in self?.policyButtonTapped() }
                )
                self.dialog.disableOutsideTapDismiss()
                self.dialog.showAnimation()
            }
            .store(in: &cancellables)

        output.isSubmitEnabled
            .assign(to: \.isEnabled, on: verificationCodeView.submitButton)
            .store(in: &cancellables)

        output.didVerifySuccess
            .sink { [weak self] in
                guard let self else { return }
                let onboardingVC = diContainer.makeOnboardingViewController()
                changeRootVC(onboardingVC)
            }
            .store(in: &cancellables)

        verificationCodeView.codeView.onTextChanged = { [weak self] text in
            self?.viewModel?.updateCode(text)
        }

        verificationCodeView.submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        verificationCodeView.notReceivedButton.addTarget(self, action: #selector(policyButtonTapped), for: .touchUpInside)
    }

    // MARK: - Action

    @objc private func submitTapped() {
        let code = verificationCodeView.codeView.text
        viewModel?.submit(code: code)
    }
    @objc private func policyButtonTapped() {
        guard let url = URL(string: "http://pf.kakao.com/_kNTvn/chat") else { return }
        let safariVC = SFSafariViewController(url: url)
        self.present(safariVC, animated: true, completion: nil)
    }


    // MARK: - Private Method

    private func exitApp() {
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            exit(0)
        }
    }
}
