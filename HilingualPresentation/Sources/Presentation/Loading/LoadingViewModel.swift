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

    // MARK: - Dependencies

    private let diaryWritingUseCase: DiaryWritingUseCase
    @Published public var diaryId: Int? = nil

    // MARK: - Init

    public init(diaryWritingUseCase: DiaryWritingUseCase) {
        self.diaryWritingUseCase = diaryWritingUseCase
        super.init()
    }

    // MARK: - State Enum

    public enum State {
        case loading
        case success
        case error
    }

    // MARK: - Properties

    private let stateSubject = CurrentValueSubject<State, Never>(.loading)
    public var statePublisher: AnyPublisher<State, Never> {
        stateSubject.eraseToAnyPublisher()
    }

    private var startTime: Date?
    private var errorCount = 0
    private let maxErrorCount = 2
    private var diaryEntity: DiaryWritingEntity?

    public let feedbackCompletedSubject = PassthroughSubject<Result<Void, Error>, Never>()

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
            .sink { [weak self] in self?.startLoadingState() }
            .store(in: &cancellables)

        input.retryTapped
            .sink { [weak self] in self?.retryFeedback() }
            .store(in: &cancellables)
        
        return Output(
            state: statePublisher,
            goToHome: input.closeTapped
        )
    }

    // MARK: - External API

    @MainActor
    public func requestFeedback(with entity: DiaryWritingEntity) {
        self.diaryEntity = entity
        postDiary(entity: entity)
    }

    // MARK: - Internal

    @MainActor
    private func retryFeedback() {
        guard let entity = diaryEntity else {
            print("❌ diaryEntity가 nil입니다. API 호출 불가")
            return
        }
        print("📡 다시 요청 - API 호출 시작")
        postDiary(entity: entity)
    }

    @MainActor
    private func startLoadingState() {
        print("🔄 Loading 상태 진입")
        stateSubject.send(.loading)
        startTime = Date()
    }

    @MainActor
    private func postDiary(entity: DiaryWritingEntity) {
        startLoadingState()

        diaryWritingUseCase.postDiaryWriting(entity)
            .sink { [weak self] completion in
                guard let self = self else { return }
                if case .failure = completion {
                    Task { @MainActor in
                        await self.handleFeedbackCompleted(success: false)
                    }
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }

                self.diaryId = response.diaryId

                Task { @MainActor in
                    await self.handleFeedbackCompleted(success: true)
                }
            }
            .store(in: &cancellables)
    }

    @MainActor
    private func handleFeedbackCompleted(success: Bool) async {
        guard let startTime = startTime else { return }

        let elapsed = Date().timeIntervalSince(startTime)
        let delay = max(3 - elapsed, 0)
        try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))

        if success {
            errorCount = 0
            stateSubject.send(.success)
        } else {
            errorCount += 1
            stateSubject.send(.error)
        }
    }
}
