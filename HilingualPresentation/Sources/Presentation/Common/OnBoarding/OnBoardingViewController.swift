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

        let input = OnBoardingViewModel.Input(
            nicknameChanged: nicknameSubject.eraseToAnyPublisher()
        )
        let output = viewModel.transform(input: input)

        output.nicknameState
            .sink { [weak self] state in
                self?.onBoardingView.nicknameTextField.updateState(state)
            }
            .store(in: &cancellables)
    }

    @objc private func nicknameDidChange() {
        nicknameSubject.send(onBoardingView.nicknameTextField.text)
    }
}
