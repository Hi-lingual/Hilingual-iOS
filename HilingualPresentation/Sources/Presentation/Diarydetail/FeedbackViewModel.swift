//
//  FeedbackViewModel.swift
//  HilingualPresentation
//
//  Created by 진소은 on 7/11/25.
//

import Combine

import HilingualDomain

public final class FeedbackViewModel: BaseViewModel{
    
    // MARK: - Input
    
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let fetchDiaryResult: AnyPublisher<[DiaryFeedbackEntity], Never>
        let errorMessage: AnyPublisher<String, Never>
    }
    
    // MARK: - Properties
    
    private let useCase: FeedbackUseCase
    
    private let feedbackSubject = PassthroughSubject<[DiaryFeedbackEntity], Never>()
    private let errorSubject = PassthroughSubject<String, Never>()
    
    public init(useCase: FeedbackUseCase) {
        self.useCase = useCase
    }
    
    func transform(input: Input) -> Output {
        input.viewDidLoad
            .sink { [weak self] in
                guard let self = self else { return }
                
                self.useCase.fetchFeedback()
                    .sink(receiveCompletion: { [weak self] completion in
                        switch completion {
                        case .failure(let error):
                            self?.errorSubject.send("조회 실패: \(error.localizedDescription)")
                        case .finished:
                            break
                        }
                    }, receiveValue: { [weak self] entity in
                        let feedbackData = entity
                        self?.feedbackSubject.send(feedbackData)
                        print("feedbackData: \(feedbackData)")
                    })
                    .store(in: &self.cancellables)
            }
            .store(in: &cancellables)
        return Output(
            fetchDiaryResult: feedbackSubject.eraseToAnyPublisher(),
            errorMessage: errorSubject.eraseToAnyPublisher()
        )
    }
}
