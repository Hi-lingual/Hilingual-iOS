//
//  DiaryDetailViewModel.swift
//  HilingualPresentation
//
//  Created by 진소은 on 7/8/25.
//

import Foundation
import Combine
import HilingualDomain

public final class DiaryDetailViewModel: BaseViewModel {
    private let diaryId: Int
    private let deleteDiaryUseCase: DeleteDiaryUseCase
    private let publishDiaryUseCase: PublishDiaryUseCase
    
    private let deleteSubject = PassthroughSubject<Void, Never>()
    private let publishSubject = PassthroughSubject<Bool, Never>()
    private let errorSubject = PassthroughSubject<String, Never>()
    
    public init(
        diaryId: Int,
        deleteDiaryUseCase: DeleteDiaryUseCase,
        publishDiaryUseCase: PublishDiaryUseCase
    ) {
        self.diaryId = diaryId
        self.deleteDiaryUseCase = deleteDiaryUseCase
        self.publishDiaryUseCase = publishDiaryUseCase
    }
    
    // MARK: - Input / Output
    
    public struct Input {
        let deleteTapped: AnyPublisher<Void, Never>
        let publishTapped: AnyPublisher<Bool, Never>
    }
    
    public struct Output {
        let deleteResult: AnyPublisher<Void, Never>
        let publishResult: AnyPublisher<Bool, Never>
        let errorMessage: AnyPublisher<String, Never>
    }
    
    public func transform(input: Input) -> Output {
        input.deleteTapped
            .sink { [weak self] in
                self?.deleteDiary()
            }
            .store(in: &cancellables)
        
        input.publishTapped
            .sink { [weak self] isPublished in
                self?.publishDiary(isPublished: isPublished)
            }
            .store(in: &cancellables)
        
        return Output(
            deleteResult: deleteSubject.eraseToAnyPublisher(),
            publishResult: publishSubject.eraseToAnyPublisher(),
            errorMessage: errorSubject.eraseToAnyPublisher()
        )
    }
    
    // MARK: - Private
    
    private func deleteDiary() {
        deleteDiaryUseCase.execute(diaryId: diaryId)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.errorSubject.send("삭제 실패: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] in
                self?.deleteSubject.send(())
            })
            .store(in: &cancellables)
    }
    
    private func publishDiary(isPublished: Bool) {
        publishDiaryUseCase.execute(diaryId: diaryId, isPublished: isPublished)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.errorSubject.send("공개 상태 변경 실패: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] in
                self?.publishSubject.send(isPublished)
            })
            .store(in: &cancellables)
    }
}
