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
        let fetchDiaryResult: AnyPublisher<DiaryDetailEntity, Never>
        let fetchFeedbackResult: AnyPublisher<[DiaryFeedbackEntity], Never>
        let errorMessage: AnyPublisher<String, Never>
    }
    
    // MARK: - Properties
    
    private let diaryDetailUseCase: DiaryDetailUseCase
    private let feedbackUseCase: FeedbackUseCase
    
    private let diaryDetailSubject = PassthroughSubject<DiaryDetailEntity, Never>()
    private let feedbackSubject = PassthroughSubject<[DiaryFeedbackEntity], Never>()
    private let errorSubject = PassthroughSubject<String, Never>()
    
    public init(diaryDetailUseCase: DiaryDetailUseCase,
                feedbackUseCase: FeedbackUseCase) {
        self.diaryDetailUseCase = diaryDetailUseCase
        self.feedbackUseCase = feedbackUseCase
    }
    
    func transform(input: Input) -> Output {
        input.viewDidLoad
            .sink { [weak self] in
                guard let self = self else { return }
                self.feedbackUseCase.fetchFeedback(diaryId: 37)
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
                
                self.diaryDetailUseCase.fetchDiaryDetail(diaryId: 37)
                                .sink(receiveCompletion: { [weak self] completion in
                                    if case let .failure(error) = completion {
                                        self?.errorSubject.send("일기 상세 조회 실패: \(error.localizedDescription)")
                                    }
                                }, receiveValue: { [weak self] detail in
                                    self?.diaryDetailSubject.send(detail)
                                })
                                .store(in: &self.cancellables)
            }
            .store(in: &cancellables)
        return Output(
            fetchDiaryResult: diaryDetailSubject.eraseToAnyPublisher(),
            fetchFeedbackResult: feedbackSubject.eraseToAnyPublisher(),
            errorMessage: errorSubject.eraseToAnyPublisher()
        )
    }
}
