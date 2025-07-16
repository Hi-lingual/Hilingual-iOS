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
    
    // MARK: - State
    
    @Published public var isLoading: Bool = false
    @Published public var error: Error?
    @Published public var successDiaryId: Int?
    
    // MARK: - Init
    
    public init(diaryWritingUseCase: DiaryWritingUseCase) {
        self.diaryWritingUseCase = diaryWritingUseCase
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
    
    public func postDiary(originalText: String, date: String, imageFile: Data?) {
        isLoading = true
        error = nil
        
        let entity = DiaryWritingEntity(originalText: originalText, date: date, imageFile: imageFile)
        
        diaryWritingUseCase.postDiaryWriting(entity)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let err):
                    self?.error = err
                }
            }, receiveValue: { [weak self] response in
                self?.successDiaryId = response.diaryId
            })
            .store(in: &cancellables)
    }
}
