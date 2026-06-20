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
    private let diaryAdWatchUseCase: DiaryAdWatchUseCase
    
    // MARK: - Properties
    
    private let stateSubject = CurrentValueSubject<State, Never>(.loading)
    private let diaryIdSubject = CurrentValueSubject<Int?, Never>(nil)
    public let feedbackCompletedSubject = PassthroughSubject<Result<Void, Error>, Never>()
    
    public var statePublisher: AnyPublisher<State, Never> { stateSubject.eraseToAnyPublisher() }
    public var diaryIdPublisher: AnyPublisher<Int?, Never> { diaryIdSubject.eraseToAnyPublisher() }
    
    private var originalText: String?
    private var date: String?
    private var imageFile: Data?
    private var isRecoveryWriting = false
    private var isAdWatched: Bool?
    
    private var startTime: Date?
    private var errorCount = 0
    private let maxErrorCount = 2

    // MARK: - Init
    
    public init(
        diaryWritingUseCase: DiaryWritingUseCase,
        uploadImageUseCase: UploadImageUseCase,
        diaryAdWatchUseCase: DiaryAdWatchUseCase
    ) {
        self.diaryWritingUseCase = diaryWritingUseCase
        self.uploadImageUseCase = uploadImageUseCase
        self.diaryAdWatchUseCase = diaryAdWatchUseCase
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
    public func postDiary(originalText: String, date: String, imageFile: Data?, isRecoveryWriting: Bool = false) {
        self.originalText = originalText
        self.date = date
        self.imageFile = imageFile
        self.isRecoveryWriting = isRecoveryWriting
        startDiaryRequest(
            originalText: originalText,
            date: date,
            imageFile: imageFile,
            isRecoveryWriting: isRecoveryWriting
        )
    }
    
    @MainActor
    public func patchAdWatch(diaryId: Int) {
        diaryAdWatchUseCase.execute(diaryId: diaryId)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("🚨 광고 시청 반영 실패: \(error)")
                }
            } receiveValue: { _ in
                print("광고 시청 반영 성공")
            }
            .store(in: &cancellables)
    }

    // MARK: - Internal
    
    @MainActor
    private func retryFeedback() {
        guard let originalText, let date else { return }
        startDiaryRequest(
            originalText: originalText,
            date: date,
            imageFile: imageFile,
            isRecoveryWriting: isRecoveryWriting
        )
    }

    @MainActor
    private func startLoadingState() {
        startTime = Date()
        stateSubject.send(.loading)
    }

    @MainActor
    private func startDiaryRequest(originalText: String, date: String, imageFile: Data?, isRecoveryWriting: Bool) {
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
                            fileKey: fileKey
                        )
                        return self.postDiary(entity, isRecoveryWriting: isRecoveryWriting)
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
                fileKey: nil
            )
            
            postDiary(entity, isRecoveryWriting: isRecoveryWriting)
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

    private func postDiary(
        _ entity: DiaryWritingEntity,
        isRecoveryWriting: Bool
    ) -> AnyPublisher<DiaryWritingResponseEntity, Error> {
        if isRecoveryWriting {
            return diaryWritingUseCase.postDiaryRecovery(entity)
        }

        return diaryWritingUseCase.postDiaryWriting(entity)
    }

    private func clearRecoveryDateIfNeeded() {
        guard isRecoveryWriting, let date else { return }

        HomeRecoveryStorage.removeRecoveredDateKey(date)
    }

    @MainActor
    private func handleFeedbackCompleted(success: Bool) async {
        if success {
            clearRecoveryDateIfNeeded()
            errorCount = 0
            stateSubject.send(.success)
        } else {
            errorCount += 1
            stateSubject.send(.error)
        }
    }
}
