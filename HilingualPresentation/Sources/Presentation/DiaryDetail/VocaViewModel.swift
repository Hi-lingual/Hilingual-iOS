//
//  VocaViewModel.swift
//  HilingualPresentation
//
//  Created by 진소은 on 7/11/25.
//

import Combine
import HilingualDomain

public final class RecommendedExpressionViewModel: BaseViewModel {
    
    let diaryId: Int
    
    // MARK: - Input
    
    public struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let bookmarkToggled: AnyPublisher<(Int, Bool), Never>
    }

    // MARK: - Output

    public struct Output {
        let fetchExpression: AnyPublisher<[RecommendedExpressionEntity.Phrase], Never>
        let errorMessage: AnyPublisher<String, Never>
        let loadError: AnyPublisher<Error, Never>
        let bookmarkError: AnyPublisher<Error, Never>
    }

    // MARK: - Properties

    private let recommendedExpressionUseCase: RecommendedExpressionUseCase
    private let toggleBookmarkUseCase: ToggleBookmarkUseCase

    private let recommendecExpressionSubject = PassthroughSubject<[RecommendedExpressionEntity.Phrase], Never>()
    private let bookmarkToggledSubject = PassthroughSubject<(Int, Bool), Never>()

    private let errorSubject = PassthroughSubject<String, Never>()
    private let loadErrorSubject = PassthroughSubject<Error, Never>()
    private let bookmarkErrorSubject = PassthroughSubject<Error, Never>()

    public init(diaryId: Int, recommendedExpressionUseCase: RecommendedExpressionUseCase, toggleBookmarkUseCase: ToggleBookmarkUseCase) {
        self.diaryId = diaryId
        self.recommendedExpressionUseCase = recommendedExpressionUseCase
        self.toggleBookmarkUseCase = toggleBookmarkUseCase
    }

    public func transform(input: Input) -> Output {
        input.viewDidLoad
            .sink { [weak self] in
                self?.fetchRecommendedExpression()
            }
            .store(in: &cancellables)
        input .bookmarkToggled
            .sink { [weak self] (phraseId, isBookmarked) in
                self?.toggleBookmark(phraseId: phraseId, isBookmarked: isBookmarked)
            }
            .store(in: &cancellables)

        return Output(
            fetchExpression: recommendecExpressionSubject.eraseToAnyPublisher(),
            errorMessage: errorSubject.eraseToAnyPublisher(),
            loadError: loadErrorSubject.eraseToAnyPublisher(),
            bookmarkError: bookmarkErrorSubject.eraseToAnyPublisher()
        )
    }

    func fetchRecommendedExpression() {
        recommendedExpressionUseCase.fetchRecommendedExpression(diaryId: diaryId)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.loadErrorSubject.send(error)
                }
            }, receiveValue: { [weak self] expressionData in
                self?.recommendecExpressionSubject.send(expressionData)
            })
            .store(in: &cancellables)
    }
    
    private func toggleBookmark(phraseId: Int, isBookmarked: Bool) {
        toggleBookmarkUseCase.execute(phraseId: phraseId, isBookmarked: isBookmarked)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.updateBookmarkState(phraseId: phraseId, isBookmarked: isBookmarked)
                case .failure(let error):
                    self?.bookmarkErrorSubject.send(error)
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }
    
    private func updateBookmarkState(phraseId: Int, isBookmarked: Bool) {
        let updated = recommendecExpressionSubject.map { items -> [RecommendedExpressionEntity.Phrase] in
            items.map { item in
                if item.phraseId == phraseId {
                    return RecommendedExpressionEntity.Phrase(
                        phraseId: item.phraseId,
                        phraseType: item.phraseType,
                        phrase: item.phrase,
                        explanation: item.explanation,
                        reason: item.reason,
                        isBookmarked: isBookmarked
                    )
                } else {
                    return item
                }
            }
        }

    }
}
