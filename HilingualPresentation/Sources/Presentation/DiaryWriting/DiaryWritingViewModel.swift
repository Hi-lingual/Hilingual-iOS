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
    
    // MARK: - State
    
    private let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    private let errorSubject = PassthroughSubject<Error, Never>()
    private let successDiaryIdSubject = PassthroughSubject<Int, Never>()
    
    public var diaryResultPublisher: AnyPublisher<Result<Int, Error>, Never> {
        let success = successDiaryIdSubject
            .map { Result<Int, Error>.success($0) }
        
        let failure = errorSubject
            .map { Result<Int, Error>.failure($0) }
        
        return Publishers.Merge(success, failure)
            .eraseToAnyPublisher()
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
    
    public init(diaryWritingUseCase: DiaryWritingUseCase, uploadImageUseCase: UploadImageUseCase) {
        self.diaryWritingUseCase = diaryWritingUseCase
        self.uploadImageUseCase = uploadImageUseCase
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
}
