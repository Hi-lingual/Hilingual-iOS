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
    
    private let deleteSubject = PassthroughSubject<Void, Never>()
    private let errorSubject = PassthroughSubject<String, Never>()
    
    public init(diaryId: Int, deleteDiaryUseCase: DeleteDiaryUseCase) {
        self.diaryId = diaryId
        self.deleteDiaryUseCase = deleteDiaryUseCase
    }
    
    // Input/Output 정의 (필요시)
    public struct Input {
        let deleteTapped: AnyPublisher<Void, Never>
    }
    
    public struct Output {
        let deleteResult: AnyPublisher<Void, Never>
        let errorMessage: AnyPublisher<String, Never>
    }
    
    public func transform(input: Input) -> Output {
        input.deleteTapped
            .sink { [weak self] in
                self?.deleteDiary()
            }
            .store(in: &cancellables)
        
        return Output(
            deleteResult: deleteSubject.eraseToAnyPublisher(),
            errorMessage: errorSubject.eraseToAnyPublisher()
        )
    }
    
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
}

