//
//  LoginOnBoardingViewController.swift
//  HilingualPresentation
//
//  Created by 성현주 on 2/12/26.
//

import UIKit
import Combine
import SnapKit

public final class LoginOnBoardingViewController: BaseUIViewController<LoginOnBoardingViewModel> {

    // MARK: - UI

    private let loginOnBoardingView = LoginOnBoardingView()
    private let startTappedSubject = PassthroughSubject<Void, Never>()

    // MARK: - Layout

    public override func setUI() {
        view.addSubviews(loginOnBoardingView)
    }

    public override func setLayout() {
        loginOnBoardingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    public override func addTarget() {
        loginOnBoardingView.nextButton.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
        loginOnBoardingView.skipButton.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
    }

    // MARK: - Bind

    public override func bind(viewModel: LoginOnBoardingViewModel) {
        let input = LoginOnBoardingViewModel.Input(
            startTapped: startTappedSubject.eraseToAnyPublisher()
        )
        let output = viewModel.transform(input: input)

        output.navigateToLogin
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let self else { return }
                let vc = self.diContainer.makeLoginViewController()
                let nav = UINavigationController(rootViewController: vc)
                changeRootVC(nav, animated: true)
            }
            .store(in: &cancellables)
    }

    // MARK: - Actions

    @objc
    private func startTapped() {
        UserDefaults.standard.set(true, forKey: "hasLoggedInBefore")
        print("[LoginOnBoardingVC] 💾 hasLoggedInBefore 저장: true")
        startTappedSubject.send()
    }

    @objc
    private func skipTapped() {
        UserDefaults.standard.set(true, forKey: "hasLoggedInBefore")
        print("[LoginOnBoardingVC] ⏭️ 건너뛰기 탭 - hasLoggedInBefore 저장: true")
        startTappedSubject.send()
    }
}
