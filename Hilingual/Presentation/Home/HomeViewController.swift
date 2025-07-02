//
//  HomeViewController.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import UIKit
import Combine

final class HomeViewController: BaseUIViewController {

    private let mainView = HomeView()
    private let viewModel: HomeViewModel
    private var cancellables = Set<AnyCancellable>()

    private let fetchTapSubject = PassthroughSubject<Void, Never>()

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setupAction()
    }

    private func setupAction() {
        mainView.fetchButton.addTarget(self, action: #selector(fetchTapped), for: .touchUpInside)
    }

    @objc private func fetchTapped() {
        fetchTapSubject.send(())
    }

    private func bind() {
        let input = HomeViewModel.Input(fetchButtonTapped: fetchTapSubject.eraseToAnyPublisher())
        let output = viewModel.transform(input: input)

        output.rateText
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                self?.mainView.rateLabel.text = text
            }
            .store(in: &cancellables)
    }
}
