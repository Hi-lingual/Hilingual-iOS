//
//  LoadingViewController.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 7/11/25.
//

import Foundation
import Combine

public final class LoadingViewController: BaseUIViewController<LoadingViewModel> {

    // MARK: - Properties

    private let loadingView = LoadingView()
    public var onRetryTapped: (() -> Void)?

    private let retryTappedSubject = PassthroughSubject<Void, Never>()
    private let closeTappedSubject = PassthroughSubject<Void, Never>()

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        addTarget()
        setStyle()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - Setup

    public func setStyle() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    public override func setUI() {
        view.addSubviews(loadingView)

        loadingView.onCloseTapped = { [weak self] in
            self?.closeTappedSubject.send(())
        }
    }

    public override func setLayout() {
        loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    public override func addTarget() {
        loadingView.feedbackButton.addTarget(self, action: #selector(feedbackButtonTapped), for: .touchUpInside)
        loadingView.closeIcon.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }

    // MARK: - Action

    @objc private func feedbackButtonTapped() {
        switch loadingView.currentState {
        case .loading:
            break
        case .success:
            goToNextView()
        case .error:
            retryButtonTapped()
        }
    }

    @objc private func retryButtonTapped() {
        retryTappedSubject.send()
    }

    @objc private func closeButtonTapped() {
        closeTappedSubject.send()
    }

    // MARK: - Bind

    public override func bind(viewModel: LoadingViewModel) {
        super.bind(viewModel: viewModel)

        let input = LoadingViewModel.Input(
            startLoading: Just(()).eraseToAnyPublisher(),
            retryTapped: retryTappedSubject.eraseToAnyPublisher(),
            closeTapped: closeTappedSubject.eraseToAnyPublisher()
        )

        let output = viewModel.transform(input: input)

        output.goToHome
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.goToHomeView() }
            .store(in: &cancellables)

        output.state
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                guard let self = self else { return }

                let viewState: LoadingView.State
                switch state {
                case .loading:
                    print("🌀 상태: 로딩 중")
                    viewState = .loading
                case .success:
                    print("✅ 상태: 성공")
                    viewState = .success
                case .error:
                    print("❌ 상태: 에러")
                    viewState = .error
                }

                self.loadingView.configure(for: viewState)
            }
            .store(in: &cancellables)
    }

    // MARK: - Navigation

    private func goToNextView() {
        guard let diaryId = viewModel?.diaryId else {
            assertionFailure("❌ diaryId가 nil입니다. DiaryDetail로 이동 불가")
            return
        }

        let detailVC = diContainer.makeDiaryDetailViewController(diaryId: diaryId)
        detailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailVC, animated: true)
    }

    private func goToHomeView() {
        navigationController?.popToRootViewController(animated: true)
    }
}
