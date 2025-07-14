//
//  WordBookViewModel.swift
//  HilingualPresentation
//
//  Created by 성현주 on 7/11/25.
//

import Foundation
import Combine

import HilingualDomain

public final class WordBookViewModel: BaseViewModel {

    // MARK: - Input / Output

    public struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let sortChanged: AnyPublisher<SortOption, Never>
        let selectedWordId: AnyPublisher<Int, Never>
        let bookmarkToggled: AnyPublisher<(Int, Bool), Never>
    }

    public struct Output {
        let wordList: AnyPublisher<[(date: String, items: [PhraseData])], Never>
        let wordDetail: AnyPublisher<PhraseData, Never>
    }

    // MARK: - Dependencies

    private let fetchWordListUseCase: WordBookUseCase
    private let toggleBookmarkUseCase: ToggleBookmarkUseCase

    // MARK: - State

    private let wordListSubject = CurrentValueSubject<[(date: String, items: [PhraseData])], Never>([])
    private let wordDetailSubject = PassthroughSubject<PhraseData, Never>()
    private var currentSortOption: SortOption = .latest

    // MARK: - Init

    public init(
        fetchWordListUseCase: WordBookUseCase,
        toggleBookmarkUseCase: ToggleBookmarkUseCase
    ) {
        self.fetchWordListUseCase = fetchWordListUseCase
        self.toggleBookmarkUseCase = toggleBookmarkUseCase
    }

    // MARK: - Transform

    public func transform(input: Input) -> Output {
        input.viewDidLoad
            .sink { [weak self] in
                self?.fetchWords(sort: self?.currentSortOption ?? .latest)
            }
            .store(in: &cancellables)

        input.sortChanged
            .sink { [weak self] option in
                self?.currentSortOption = option
                self?.fetchWords(sort: option)
            }
            .store(in: &cancellables)

        input.selectedWordId
            .sink { [weak self] id in
                self?.fetchWordDetail(id: id)
            }
            .store(in: &cancellables)

        input.bookmarkToggled
            .sink { [weak self] (phraseId, isBookmarked) in
                self?.toggleBookmark(phraseId: phraseId, isBookmarked: isBookmarked)
            }
            .store(in: &cancellables)


        return Output(
            wordList: wordListSubject.eraseToAnyPublisher(),
            wordDetail: wordDetailSubject.eraseToAnyPublisher()
        )
    }

    // MARK: - Private Methods

    private func fetchWords(sort: SortOption) {
        fetchWordListUseCase.execute(sort: sort)
            .map { wordList in
                wordList.map { (date, items) in
                    let phraseDataList = items.map { entity in
                        PhraseData(
                            phraseId: entity.phraseId,
                            phraseType: entity.phraseType,
                            phrase: entity.phrase,
                            explanation: entity.explanation,
                            example: entity.example,
                            isMarked: entity.isMarked,
                            created_at: entity.createdAt
                        )
                    }
                    return (date: date, items: phraseDataList)
                }
            }
            .replaceError(with: [])
            .sink { [weak self] result in
                self?.wordListSubject.send(result)
            }
            .store(in: &cancellables)
    }

    private func fetchWordDetail(id: Int) {
        fetchWordListUseCase.getWordDetail(id: id)
            .map {
                PhraseData(
                    phraseId: $0.phraseId,
                    phraseType: $0.phraseType,
                    phrase: $0.phrase,
                    explanation: $0.explanation,
                    example: $0.example,
                    isMarked: $0.isMarked,
                    created_at: $0.createdAt
                )
            }
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] in self?.wordDetailSubject.send($0) })
            .store(in: &cancellables)
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
        let updated = wordListSubject.value.map { (date, items) -> (String, [PhraseData]) in
            let updatedItems = items.map { item in
                if item.phraseId == phraseId {
                    var updatedItem = item
                    updatedItem.isMarked = isBookmarked
                    return updatedItem
                }
                return item
            }
            return (date, updatedItems)
        }
        wordListSubject.send(updated)
    }
}
