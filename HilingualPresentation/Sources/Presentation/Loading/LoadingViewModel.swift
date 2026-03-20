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
    private let uploadImageUseCase: UploadImageUseCase
    
    // MARK: - Properties
    
    private let stateSubject = CurrentValueSubject<State, Never>(.loading)
    private let diaryIdSubject = CurrentValueSubject<Int?, Never>(nil)
    public let feedbackCompletedSubject = PassthroughSubject<Result<Void, Error>, Never>()
    
    public var statePublisher: AnyPublisher<State, Never> { stateSubject.eraseToAnyPublisher() }
    public var diaryIdPublisher: AnyPublisher<Int?, Never> { diaryIdSubject.eraseToAnyPublisher() }
    
    private var originalText: String?
    private var date: String?
    private var imageFile: Data?
    private var isAdWatched: Bool?
    
    private var startTime: Date?
    private var errorCount = 0
    private let maxErrorCount = 2

    // MARK: - Init
    public init(
        diaryWritingUseCase: DiaryWritingUseCase,
        uploadImageUseCase: UploadImageUseCase
    ) {
        self.diaryWritingUseCase = diaryWritingUseCase
        self.uploadImageUseCase = uploadImageUseCase
        super.init()
    }

    // MARK: - State Enum

    public enum State {
        case loading
        case success
        case error
    }
    
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

    // MARK: - Transfor

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
    public func postDiary(originalText: String, date: String, imageFile: Data?, isAdWatched: Bool) {
        self.originalText = originalText
        self.date = date
        self.imageFile = imageFile
        self.isAdWatched = isAdWatched
        startDiaryRequest(originalText: originalText, date: date, imageFile: imageFile, isAdWatched: isAdWatched)
    }

    // MARK: - Internal
    
    @MainActor
    private func retryFeedback() {
        guard let originalText, let date, let isAdWatched else { return }
        startDiaryRequest(originalText: originalText, date: date, imageFile: imageFile, isAdWatched: isAdWatched)
    }

    @MainActor
    private func startLoadingState() {
        startTime = Date()
        stateSubject.send(.loading)
    }

    @MainActor
    private func startDiaryRequest(originalText: String, date: String, imageFile: Data?, isAdWatched: Bool) {
        startLoadingState()
        let contentType = "image/jpeg"

        if let data = imageFile {
            uploadImageUseCase
                .execute(data: data, contentType: contentType, purpose: "DIARY_IMAGE")
                    .receive(on: DispatchQueue.main)
                    .flatMap { [weak self] fileKey -> AnyPublisher<DiaryWritingResponseEntity, Error> in
                        guard let self else {
                            return Empty<DiaryWritingResponseEntity, Error>().eraseToAnyPublisher()
                        }
                        let entity = DiaryWritingEntity(
                            originalText: originalText,
                            date: date,
                            fileKey: fileKey,
                            isAdWatched: isAdWatched
                        )
                        return self.diaryWritingUseCase.postDiaryWriting(entity)
                    }
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    guard let self else { return }
                    if case .failure = completion {
                        Task { @MainActor in
                            await self.handleFeedbackCompleted(success: false)
                        }
                    }
                } receiveValue: { [weak self] response in
                    guard let self else { return }
                    self.diaryIdSubject.send(response.diaryId)
                    Task { @MainActor in
                        await self.handleFeedbackCompleted(success: true)
                    }
                }
                .store(in: &cancellables)
            
        } else {
            let entity = DiaryWritingEntity(
                originalText: originalText,
                date: date,
                fileKey: nil,
                isAdWatched: isAdWatched
            )
            
            diaryWritingUseCase.postDiaryWriting(entity)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    guard let self else { return }
                    if case .failure = completion {
                        Task { @MainActor in
                            await self.handleFeedbackCompleted(success: false)
                        }
                    }
                } receiveValue: { [weak self] response in
                    guard let self else { return }
                    self.diaryIdSubject.send(response.diaryId)
                    Task { @MainActor in
                        await self.handleFeedbackCompleted(success: true)
                    }
                }
                .store(in: &cancellables)
        }
    }

    @MainActor
    private func handleFeedbackCompleted(success: Bool) async {
        if success {
            errorCount = 0
            stateSubject.send(.success)
        } else {
            errorCount += 1
            stateSubject.send(.error)
        }
    }
}
