//
//  LoadingViewModel.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 7/11/25.
//

import Foundation
import Combine

import HilingualDomain

public final class LoadingViewModel: BaseViewModel {
    
    private let diaryWritingUseCase: DiaryWritingUseCase
    
    public init(diaryWritingUseCase: DiaryWritingUseCase) {
        self.diaryWritingUseCase = diaryWritingUseCase
        super.init()
    }
    
    public enum State {
        case loading
        case success
        case error
    }
    
    // MARK: - Properties
    
    @Published private(set) var state: State = .loading
    private var startTime: Date?
    
    private var errorCount = 0
    let maxErrorCount = 2
    
    public let feedbackCompletedSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Input / Output
    
    public struct Input {
        let startLoading: AnyPublisher<Void, Never>
        let retryTapped: AnyPublisher<Void, Never>
        let closeTapped: AnyPublisher<Void, Never>
    }
    
    public struct Output {
        let state: AnyPublisher<State, Never>
        let goToHome: AnyPublisher<Void, Never>
    }
    
    // MARK: - Transform
    @MainActor
    public func transform(input: Input) -> Output {
        input.startLoading
            .sink { [weak self] in
                guard let self = self else { return }
                Task { @MainActor in
                    await self.startLoading()
                }
            }
            .store(in: &cancellables)
        
        input.retryTapped
            .sink { [weak self] in
                guard let self = self else { return }
                Task { @MainActor in
                    await self.startLoading()
                }
            }
            .store(in: &cancellables)
        
        let goToHome = input.closeTapped
            .eraseToAnyPublisher()
        
        feedbackCompletedSubject
            .sink { [weak self] in
                guard let self = self else { return }
                Task { @MainActor in
                    await self.handleFeedbackCompleted(success: true)
                }
            }
            .store(in: &cancellables)
        
        return Output(
            state: $state.eraseToAnyPublisher(),
            goToHome: goToHome
        )
    }
    
    // MARK: - Private methods
    
    @MainActor
    private func startLoading() async {
        state = .loading
        startTime = Date()
        
        // 실제 API 콜이 들어갈 자리
        // 테스트용: 1초 대기 후 결과 시뮬레이션
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        let success = Bool.random()
        await handleFeedbackCompleted(success: success)
    }
    
    @MainActor
    private func handleFeedbackCompleted(success: Bool) async {
        guard let startTime = startTime else { return }
        let elapsed = Date().timeIntervalSince(startTime)
        let delay = max(3 - elapsed, 0)
        
        try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        
        if success {
            errorCount = 0
            state = .success
        } else {
            errorCount += 1
            if errorCount >= maxErrorCount {
                state = .error
            } else {
                await startLoading()
            }
        }
    }
}
