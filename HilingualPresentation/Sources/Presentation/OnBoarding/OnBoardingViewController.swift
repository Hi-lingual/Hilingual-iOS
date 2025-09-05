//
//  OnBoardingViewController.swift
//  HilingualPresentation
//
//  Created by 성현주 on 7/8/25.
//

import Foundation
import Combine

public final class OnBoardingViewController: BaseUIViewController<OnBoardingViewModel> {

    // MARK: - Properties
    
    private let onBoardingView = OnBoardingView()
    private let nicknameSubject = PassthroughSubject<String, Never>()
    private let startTappedSubject = PassthroughSubject<Bool, Never>()
    private let agreementModal = AgreementModalView()

    // MARK: - UI

    public override func setUI() {
        view.addSubviews(onBoardingView, agreementModal)
    }

    public override func setLayout() {
        onBoardingView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        agreementModal.isHidden = true
        agreementModal.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    // MARK: - Navigation
    public override func navigationType() -> NavigationType? {
        .titleOnly("프로필 작성")
    }

    // MARK: - Bind
    public override func bind(viewModel: OnBoardingViewModel) {
        onBoardingView.nicknameTextField.textField.addTarget(
            self,
            action: #selector(nicknameDidChange),
            for: .editingChanged
        )

        onBoardingView.startButton.addTarget(
            self,
            action: #selector(showAgreementModal),
            for: .touchUpInside
        )

        let input = OnBoardingViewModel.Input(
            nicknameChanged: nicknameSubject.eraseToAnyPublisher(),
            startTapped: startTappedSubject.eraseToAnyPublisher()
        )

        let output = viewModel.transform(input: input)

        output.nicknameState
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                self?.onBoardingView.nicknameTextField.updateState(state)
            }
            .store(in: &cancellables)

        output.startButtonEnabled
            .receive(on: RunLoop.main)
            .sink { [weak self] isEnabled in
                self?.onBoardingView.startButton.isEnabled = isEnabled
            }
            .store(in: &cancellables)

        output.signUpResult
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let self else { return }
                let homeVC = diContainer.makeTabBarViewController()
                changeRootVC(homeVC, animated: true)
            }
            .store(in: &cancellables)
    }

    // MARK: - Actions

    @objc
    private func nicknameDidChange() {
        nicknameSubject.send(onBoardingView.nicknameTextField.text)
    }

    @objc
    private func showAgreementModal() {
        agreementModal.onStart = { [weak self] in
            guard let self else { return }
            let adAgree = self.agreementModal.isAdAgreeSelected
            self.startTappedSubject.send(adAgree)
        }
        agreementModal.isHidden = false
        agreementModal.showAnimation()
    }
}
