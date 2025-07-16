//
//  VocaViewModel.swift
//  HilingualPresentation
//
//  Created by 진소은 on 7/11/25.
//

import Combine
import HilingualDomain

public final class VocaViewModel: BaseViewModel {
    
    private let diaryId: Int
    
    // MARK: - Input
    
    public struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let bookmarkToggled: AnyPublisher<(Int, Bool), Never>
    }

    // MARK: - Output

    public struct Output {
        let fetchVoca: AnyPublisher<[RecommendedVocaEntity.Phrase], Never>
        let errorMessage: AnyPublisher<String, Never>
    }

    // MARK: - Properties

    private let recommendedVocaUseCase: RecommendedUseCase
    private let toggleBookmarkUseCase: ToggleBookmarkUseCase

    private let recommendecVocaSubject = PassthroughSubject<[RecommendedVocaEntity.Phrase], Never>()
    private let bookmarkToggledSubject = PassthroughSubject<(Int, Bool), Never>()
    
    private let errorSubject = PassthroughSubject<String, Never>()

    public init(diaryId: Int, recommendedVocaUseCase: RecommendedUseCase, toggleBookmarkUseCase: ToggleBookmarkUseCase) {
        self.diaryId = diaryId
        self.recommendedVocaUseCase = recommendedVocaUseCase
        self.toggleBookmarkUseCase = toggleBookmarkUseCase
    }

    public func transform(input: Input) -> Output {
        input.viewDidLoad
            .sink { [weak self] in
                guard let self = self else { return }

                self.recommendedVocaUseCase.fetchRecommendedVoca(diaryId: diaryId)
                    .sink(receiveCompletion: { [weak self] completion in
                        switch completion {
                        case .failure(let error):
                            self?.errorSubject.send("조회 실패: \(error.localizedDescription)")
                        case .finished:
                            break
                        }
                    }, receiveValue: { [weak self] vocaData in
                        self?.recommendecVocaSubject.send(vocaData)
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
            fetchVoca: recommendecVocaSubject.eraseToAnyPublisher(),
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
        let updated = recommendecVocaSubject.map { items -> [RecommendedVocaEntity.Phrase] in
            items.map { item in
                if item.phraseId == phraseId {
                    return RecommendedVocaEntity.Phrase(
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
