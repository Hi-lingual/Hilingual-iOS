//
//  HomeViewController.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Foundation

public final class HomeViewController: BaseUIViewController<HomeViewModel> {

    // MARK: - Properties

    private let mainView = HomeView()

    public override func loadView() {
        self.view = mainView
    }

    public override func navigationType() -> NavigationType? {
            return .backTitleMenu("나의 단어장")
        }

    // MARK: - Bind

    public override func bind(viewModel: HomeViewModel) {
        super.bind(viewModel: viewModel)

        let input = makeInput()
        let output = viewModel.transform(input: input)

        bindOutput(output)
    }

    private func makeInput() -> HomeViewModel.Input {
        return HomeViewModel.Input(
            fetchButtonTapped: mainView.fetchButton
                .publisher(for: .touchUpInside)
        )
    }

    private func bindOutput(_ output: HomeViewModel.Output) {
        output.rateText
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                self?.mainView.rateLabel.text = text
            }
            .store(in: &cancellables)
    }
}
