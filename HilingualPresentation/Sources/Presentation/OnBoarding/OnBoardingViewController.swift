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

    // MARK: - Custom Method

    public override func setUI() {
        view.addSubviews(onBoardingView)
    }

    public override func setLayout() {
        onBoardingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Navigation

    public override func navigationType() -> NavigationType? {
        return .titleOnly("프로필 작성")
    }

    // MARK: - Bind

    public override func bind(viewModel: OnBoardingViewModel) {
        onBoardingView.nicknameTextField.textField.addTarget(
            self,
            action: #selector(nicknameDidChange),
            for: .editingChanged
        )

        let input = makeInput()
        let output = viewModel.transform(input: input)

        bindOutput(output)
    }

    private func makeInput() -> OnBoardingViewModel.Input {
        return OnBoardingViewModel.Input(
            nicknameChanged: nicknameSubject.eraseToAnyPublisher(),
            startTapped: onBoardingView.startButton.publisher(for: .touchUpInside)
        )
    }

    private func bindOutput(_ output: OnBoardingViewModel.Output) {
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

    // MARK: - Action

    @objc
    private func nicknameDidChange() {
        nicknameSubject.send(onBoardingView.nicknameTextField.text)
    }
}
