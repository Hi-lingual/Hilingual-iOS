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
    }

    // MARK: - Properties

    private let recommendedExpressionUseCase: RecommendedExpressionUseCase
    private let toggleBookmarkUseCase: ToggleBookmarkUseCase

    private let recommendecExpressionSubject = PassthroughSubject<[RecommendedExpressionEntity.Phrase], Never>()
    private let bookmarkToggledSubject = PassthroughSubject<(Int, Bool), Never>()
    
    private let errorSubject = PassthroughSubject<String, Never>()

    public init(diaryId: Int, recommendedExpressionUseCase: RecommendedExpressionUseCase, toggleBookmarkUseCase: ToggleBookmarkUseCase) {
        self.diaryId = diaryId
        self.recommendedExpressionUseCase = recommendedExpressionUseCase
        self.toggleBookmarkUseCase = toggleBookmarkUseCase
    }

    public func transform(input: Input) -> Output {
        input.viewDidLoad
            .sink { [weak self] in
                guard let self = self else { return }

                self.recommendedExpressionUseCase.fetchRecommendedExpression(diaryId: diaryId)
                    .sink(receiveCompletion: { [weak self] completion in
                        switch completion {
                        case .failure(let error):
                            self?.errorSubject.send("조회 실패: \(error.localizedDescription)")
                        case .finished:
                            break
                        }
                    }, receiveValue: { [weak self] ExpressionData in
                        self?.recommendecExpressionSubject.send(ExpressionData)
                    })
                    .store(in: &self.cancellables)
            }
            .store(in: &cancellables)
        input .bookmarkToggled
            .sink { [weak self] (phraseId, isBookmarked) in
                self?.toggleBookmark(phraseId: phraseId, isBookmarked: isBookmarked)
            }
            .store(in: &cancellables)

        return Output(
            fetchExpression: recommendecExpressionSubject.eraseToAnyPublisher(),
            errorMessage: errorSubject.eraseToAnyPublisher()
        )
    }
    
    private func toggleBookmark(phraseId: Int, isBookmarked: Bool) {
        toggleBookmarkUseCase.execute(phraseId: phraseId, isBookmarked: isBookmarked)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.updateBookmarkState(phraseId: phraseId, isBookmarked: isBookmarked)
                case .failure(let error):
                    print("북마크 토글 실패: \(error.localizedDescription)")
                }
            }, receiveValue: { _ in
            })
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
