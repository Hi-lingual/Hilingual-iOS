//
//  DiaryWritingViewModel.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 7/8/25.
//

import Foundation
import Combine

import HilingualDomain

public final class DiaryWritingViewModel: BaseViewModel {
    
    // MARK: - Dependencies
    
    private let diaryWritingUseCase: DiaryWritingUseCase
    private let uploadImageUseCase: UploadImageUseCase
    private let saveTemporaryDiaryUseCase: SaveTemporaryDiaryUseCase
    private let fetchTemporaryDiaryUseCase: FetchTemporaryDiaryUseCase
    
    // MARK: - State
    
    private let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    private let errorSubject = PassthroughSubject<Error, Never>()
    private let successDiaryIdSubject = PassthroughSubject<Int, Never>()
    private let temporarySaveCompleted = PassthroughSubject<Void, Never>()
    let draftLoaded = PassthroughSubject<TemporaryDiaryEntity?, Never>()
    
    
    private var temporarySaveCancellables = Set<AnyCancellable>()
    
    public var diaryResultPublisher: AnyPublisher<Result<Int, Error>, Never> {
        let success = successDiaryIdSubject
            .map { Result<Int, Error>.success($0) }
        
        let failure = errorSubject
            .map { Result<Int, Error>.failure($0) }
        
        return Publishers.Merge(success, failure)
            .eraseToAnyPublisher()
    }
    
    var didTemporarySaveComplete: AnyPublisher<Void, Never> {
        temporarySaveCompleted.eraseToAnyPublisher()
    }
    
    public var isLoading: AnyPublisher<Bool, Never> {
        isLoadingSubject.eraseToAnyPublisher()
    }
    
    public var error: AnyPublisher<Error, Never> {
        errorSubject.eraseToAnyPublisher()
    }
    
    public var successDiaryId: AnyPublisher<Int, Never> {
        successDiaryIdSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Init
    
    public init(
        diaryWritingUseCase: DiaryWritingUseCase,
        uploadImageUseCase: UploadImageUseCase,
        saveTemporaryDiaryUseCase: SaveTemporaryDiaryUseCase,
        fetchTemporaryDiaryUseCase: FetchTemporaryDiaryUseCase

    ) {
        self.diaryWritingUseCase = diaryWritingUseCase
        self.uploadImageUseCase = uploadImageUseCase
        self.saveTemporaryDiaryUseCase = saveTemporaryDiaryUseCase
        self.fetchTemporaryDiaryUseCase = fetchTemporaryDiaryUseCase
        super.init()
    }
    
    // MARK: - Input / Output
    
    public struct Input {
        let textCount: AnyPublisher<Int, Never>
    }
    
    public struct Output {
        let buttonActive: AnyPublisher<Bool, Never>
    }
    
    // MARK: - Transform
    
    public func transform(input: Input) -> Output {
        let buttonActive = input.textCount
            .map { $0 >= 10 }
            .removeDuplicates()
            .eraseToAnyPublisher()
        
        return Output(buttonActive: buttonActive)
    }
    
    // MARK: - Temporary Save
    
    public func didTapTemporarySave(text: String, date: Date, imageData: Data?) {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || imageData != nil else {
            print("⚠️ 내용 또는 이미지를 입력하세요")
            return
        }

        let entity = TemporaryDiaryEntity(
            text: text,
            date: date,
            image: imageData
        )

        print("🧩 ViewModel: 임시저장 실행됨")

        saveTemporaryDiaryUseCase.execute(entity)
            .handleEvents(
                receiveSubscription: { _ in print("🔵 ViewModel 구독 시작됨") },
                receiveOutput:       { _ in print("🟣 ViewModel receiveOutput") },
                receiveCompletion:   { completion in print("🔴 ViewModel completion: \(completion)") }
            )
            .sink { [weak self] completion in
                print("🍏 ViewModel sink completion: \(completion)")
                if case .failure(let error) = completion {
                    self?.errorSubject.send(error)
                }
            } receiveValue: { [weak self] _ in
                print("🍎 ViewModel sink receiveValue")
                self?.temporarySaveCompleted.send(())
            }
            .store(in: &temporarySaveCancellables)
    }
    
    public func loadDraftIfExists(for date: Date) {
        fetchTemporaryDiaryUseCase.execute(date)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] draft in
                    self?.draftLoaded.send(draft)
                }
            )
            .store(in: &cancellables)
    }
}
