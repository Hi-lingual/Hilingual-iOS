//
//  FeedbackViewModel.swift
//  HilingualPresentation
//
//  Created by 진소은 on 7/11/25.
//

import Combine
import HilingualDomain

public final class FeedbackViewModel: BaseViewModel{
    
    let diaryId: Int
    
    // MARK: - Input
    
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let fetchDiaryResult: AnyPublisher<DiaryDetailEntity, Never>
        let fetchFeedbackResult: AnyPublisher<[DiaryFeedbackEntity], Never>
        let fetchTopicResult: AnyPublisher<TopicEntity, Never>
        let errorMessage: AnyPublisher<String, Never>
        let feedbackError: AnyPublisher<Error, Never>
        let diaryDetailError: AnyPublisher<Error, Never>
    }
    
    // MARK: - Properties
    
    private let diaryDetailUseCase: DiaryDetailUseCase
    private let feedbackUseCase: FeedbackUseCase
    private let homeUseCase: HomeUseCase
    
    private let diaryDetailSubject = PassthroughSubject<DiaryDetailEntity, Never>()
    private let feedbackSubject = PassthroughSubject<[DiaryFeedbackEntity], Never>()
    private let topicSubject = PassthroughSubject<TopicEntity, Never>()
    private let errorSubject = PassthroughSubject<String, Never>()
    private let feedbackErrorSubject = PassthroughSubject<Error, Never>()
    private let diaryDetailErrorSubject = PassthroughSubject<Error, Never>()
    
    public init(
        diaryId: Int,
        diaryDetailUseCase: DiaryDetailUseCase,
        feedbackUseCase: FeedbackUseCase,
        homeUseCase: HomeUseCase
    ) {
        self.diaryId = diaryId
        self.diaryDetailUseCase = diaryDetailUseCase
        self.feedbackUseCase = feedbackUseCase
        self.homeUseCase = homeUseCase
    }
    
    func transform(input: Input) -> Output {
        input.viewDidLoad
            .sink { [weak self] in
                guard let self = self else { return }

                self.fetchFeedback()
                self.fetchDiaryDetail()
            }
            .store(in: &cancellables)
        
        
        return Output(
            fetchDiaryResult: diaryDetailSubject.eraseToAnyPublisher(),
            fetchFeedbackResult: feedbackSubject.eraseToAnyPublisher(),
            fetchTopicResult: topicSubject.eraseToAnyPublisher(),
            errorMessage: errorSubject.eraseToAnyPublisher(),
            feedbackError: feedbackErrorSubject.eraseToAnyPublisher(),
            diaryDetailError: diaryDetailErrorSubject.eraseToAnyPublisher()
        )
    }

    func fetchFeedback() {
        feedbackUseCase.fetchFeedback(diaryId: diaryId)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.feedbackErrorSubject.send(error)
                }
            }, receiveValue: { [weak self] entity in
                self?.feedbackSubject.send(entity)
            })
            .store(in: &cancellables)
    }

    func fetchDiaryDetail() {
        diaryDetailUseCase.fetchDiaryDetail(diaryId: diaryId)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case let .failure(error) = completion {
                        self?.diaryDetailErrorSubject.send(error)
                    }
                },
                receiveValue: { [weak self] detail in
                    guard let self else { return }

                    self.diaryDetailSubject.send(detail)
                    let topicDate = DisplayDateFormatter.normalizedAPIDate(detail.date)

                    self.homeUseCase.fetchTopic(for: topicDate)
                        .sink(
                            receiveCompletion: { completion in
                                if case let .failure(error) = completion {
                                    print("일기 상세화면 - 주제 조회 실패:", error)
                                }
                            },
                            receiveValue: { [weak self] topic in
                                guard let topic else { return }
                                self?.topicSubject.send(topic)
                            }
                        )
                        .store(in: &self.cancellables)
                }
            )
            .store(in: &cancellables)
    }
}
