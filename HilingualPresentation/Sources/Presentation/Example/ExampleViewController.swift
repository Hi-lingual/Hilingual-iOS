//
//  HomeViewController.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Foundation

public final class ExampleViewController: BaseUIViewController<HomeViewModel> {

    // MARK: - Properties

    private let homeView = HomeView()

    // MARK: - Custom Method

    public override func setUI() {
        view.addSubviews(homeView)
    }

    public override func setLayout() {
        homeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
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
            fetchButtonTapped: homeView.fetchButton
                .publisher(for: .touchUpInside)
        )
    }

    private func bindOutput(_ output: HomeViewModel.Output) {
        output.rateText
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                self?.homeView.rateLabel.text = text
            }
            .store(in: &cancellables)
    }
}
