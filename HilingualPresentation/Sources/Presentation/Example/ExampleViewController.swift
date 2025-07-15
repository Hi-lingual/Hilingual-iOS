////
////  HomeViewController.swift
////  Hilingual
////
////  Created by 성현주 on 7/2/25.
////
//
//import Foundation
//
//public final class ExampleViewController: BaseUIViewController<ExampleViewModel> {
//
//    // MARK: - Properties
//
//    private let exampleView = ExampleView()
//
//    // MARK: - Custom Method
//
//    public override func setUI() {
//        view.addSubviews(exampleView)
//    }
//
//    public override func setLayout() {
//        exampleView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//    }
//
//    public override func navigationType() -> NavigationType? {
//        return .backTitleMenu("나의 단어장")
//    }
//
//    // MARK: - Bind
//
//    public override func bind(viewModel: ExampleViewModel) {
//        super.bind(viewModel: viewModel)
//
//        let input = makeInput()
//        let output = viewModel.transform(input: input)
//
//        bindOutput(output)
//    }
//
//    private func makeInput() -> ExampleViewModel.Input {
//        return ExampleViewModel.Input(
//            fetchButtonTapped: exampleView.fetchButton
//                .publisher(for: .touchUpInside)
//        )
//    }
//
//    private func bindOutput(_ output: ExampleViewModel.Output) {
//        output.rateText
//            .receive(on: RunLoop.main)
//            .sink { [weak self] text in
//                self?.exampleView.rateLabel.text = text
//            }
//            .store(in: &cancellables)
//    }
//}
