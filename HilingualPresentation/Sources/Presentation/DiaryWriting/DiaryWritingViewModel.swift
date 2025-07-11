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
