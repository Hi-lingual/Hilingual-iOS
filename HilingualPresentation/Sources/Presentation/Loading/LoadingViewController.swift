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
    public var onRetryTapped: (() -> Void)? // 재요청 트리거

    private let retryTappedSubject = PassthroughSubject<Void, Never>()
    private let closeTappedSubject = PassthroughSubject<Void, Never>()

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        addTarget()
        setStyle()
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
            if let diaryId = viewModel?.diaryId {
                self.goToNextView(with: diaryId)
            } else {
                print("❌ diaryId가 nil이라서 화면 전환 안 됨")
            }
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
            .combineLatest(viewModel.$diaryId)
            .receive(on: RunLoop.main)
            .sink { [weak self] state, diaryId in
                guard let self = self else { return }

                let viewState: LoadingView.State
                switch state {
                case .loading:
                    print("🌀 상태: 로딩 중")
                    viewState = .loading
                case .success:
                    print("✅ 상태: 성공")
                    guard let diaryId = diaryId else {
                        print("❌ diaryId가 nil인데 success 상태? 로직 확인 필요")
                        return
                    }
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

    private func goToNextView(with diaryId: Int) {
        let diaryDetailVC = self.diContainer.makeDiaryDetailViewController(diaryId: diaryId)
        navigationController?.pushViewController(diaryDetailVC, animated: true)
    }
    
    private func goToHomeView() {
        navigationController?.popToRootViewController(animated: true)
    }
}
