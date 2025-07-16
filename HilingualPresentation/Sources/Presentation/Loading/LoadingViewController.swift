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
    
    private let retryTappedSubject = PassthroughSubject<Void, Never>()
    private let closeTappedSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        addTarget()
        setStyle()
    }
    
    // MARK: - Setup Methods
    
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
        loadingView.feedbackButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        loadingView.closeIcon.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }

    @objc private func retryButtonTapped() {
        retryTappedSubject.send(())
    }
    
    @objc private func closeButtonTapped() {
        closeTappedSubject.send(())
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
            .sink { [weak self] in
                self?.goToHomeView()
            }
            .store(in: &cancellables)
        
        output.state
            .receive(on: RunLoop.main)
            .sink { [weak self] viewModelState in
                guard let self = self else { return }
                
                let viewState: LoadingView.State
                switch viewModelState {
                case .loading: viewState = .loading
                case .success:
                    viewState = .success
                    self.goToNextView()
                case .error:   viewState = .error
                }
                self.loadingView.configure(for: viewState)
            }
            .store(in: &cancellables)
    }
    
    private func goToNextView() {
        let dairyDetailVC = self.diContainer.makeDiaryDetailViewController()
        navigationController?.pushViewController(dairyDetailVC, animated: true)
    }
    
    private func goToHomeView() {
        navigationController?.popViewController(animated: true)
    }
}
