//
//  WordBookViewModel.swift
//  HilingualPresentation
//
//  Created by 성현주 on 7/11/25.
//잭

import Foundation
import Combine

import HilingualDomain

public final class WordBookViewModel: BaseViewModel {

    // MARK: - Input / Output

    public struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let sortChanged: AnyPublisher<SortOption, Never>
        let unmemorizedOnlyChanged: AnyPublisher<Bool, Never>
        let selectedWordId: AnyPublisher<Int, Never>
        let bookmarkToggled: AnyPublisher<(Int, Bool), Never>
        let refreshTriggered: AnyPublisher<Void, Never>
        let studyRequested: AnyPublisher<Void, Never>
    }

    public struct Output {
        let wordList: AnyPublisher<[(date: String, items: [PhraseData])], Never>
        let wordDetail: AnyPublisher<PhraseData, Never>
        let studyWords: AnyPublisher<[PhraseData], Never>
        let loadError: AnyPublisher<Error, Never>
        let actionError: AnyPublisher<Error, Never>
    }

    // MARK: - Dependencies

    private let fetchWordListUseCase: WordBookUseCase
    private let toggleBookmarkUseCase: ToggleBookmarkUseCase

    // MARK: - State

    private let wordListSubject = CurrentValueSubject<[(date: String, items: [PhraseData])], Never>([])
    private let wordDetailSubject = PassthroughSubject<PhraseData, Never>()
    private let studyWordsSubject = PassthroughSubject<[PhraseData], Never>()
    private let loadErrorSubject = PassthroughSubject<Error, Never>()
    private let actionErrorSubject = PassthroughSubject<Error, Never>()
    private var currentSortOption: SortOption = .latest
    private var currentUnmemorizedOnly: Bool = false

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
                guard let self else { return }
                self.fetchWords(sort: self.currentSortOption, unmemorizedOnly: self.currentUnmemorizedOnly)
            }
            .store(in: &cancellables)

        input.sortChanged
            .sink { [weak self] option in
                guard let self else { return }
                self.currentSortOption = option
                self.fetchWords(sort: option, unmemorizedOnly: self.currentUnmemorizedOnly)
            }
            .store(in: &cancellables)

        input.unmemorizedOnlyChanged
            .sink { [weak self] isOn in
                guard let self else { return }
                self.currentUnmemorizedOnly = isOn
                self.fetchWords(sort: self.currentSortOption, unmemorizedOnly: isOn)
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

        input.refreshTriggered
               .sink { [weak self] in
                   guard let self else { return }
                   self.fetchWords(sort: self.currentSortOption, unmemorizedOnly: self.currentUnmemorizedOnly)
               }
               .store(in: &cancellables)

        input.studyRequested
            .sink { [weak self] in
                self?.fetchStudyWords()
            }
            .store(in: &cancellables)

        return Output(
            wordList: wordListSubject.eraseToAnyPublisher(),
            wordDetail: wordDetailSubject.eraseToAnyPublisher(),
            studyWords: studyWordsSubject.eraseToAnyPublisher(),
            loadError: loadErrorSubject.eraseToAnyPublisher(),
            actionError: actionErrorSubject.eraseToAnyPublisher()
        )
    }

    // MARK: - Private Methods

    private func fetchWords(sort: SortOption, unmemorizedOnly: Bool) {
        fetchWordListUseCase.execute(sort: sort, unmemorizedOnly: unmemorizedOnly)
            .map { wordList in
                wordList.map { (date, items) in
                    let phraseDataList = items.map { entity in
                        PhraseData(
                            phraseId: Int64(entity.phraseId),
                            phraseType: entity.phraseType,
                            phrase: entity.phrase,
                            explanation: entity.explanation ?? "",
                            reason: "",
                            createdAt: DisplayDateFormatter.wordSavedSource(
                                writtenFrom: entity.writtenFrom,
                                writtenDate: entity.writtenDate,
                                savedRoot: entity.savedRoot
                            ),
                            isMarked: entity.isMarked,
                            isMemorized: entity.isMemorized
                        )
                    }
                    return (date: date, items: phraseDataList)
                }
            }
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.loadErrorSubject.send(error)
                }
            }, receiveValue: { [weak self] result in
                self?.wordListSubject.send(result)
            })
            .store(in: &cancellables)
    }


    private func fetchWordDetail(id: Int) {
        let memorizedById: [Int64: Bool] = Dictionary(
            wordListSubject.value.flatMap { $0.items }.map { ($0.phraseId, $0.isMemorized) },
            uniquingKeysWith: { first, _ in first }
        )

        fetchWordListUseCase.getWordDetail(id: id)
            .map {
                PhraseData(
                    phraseId: Int64($0.phraseId),
                    phraseType: $0.phraseType,
                    phrase: $0.phrase,
                    explanation: $0.explanation ?? "",
                    reason: "",
                    createdAt: DisplayDateFormatter.wordSavedSource(
                        writtenFrom: $0.writtenFrom,
                        writtenDate: $0.writtenDate,
                        savedRoot: $0.savedRoot
                    ),
                    isMarked: $0.isMarked,
                    isMemorized: memorizedById[Int64($0.phraseId)] ?? false
                )
            }
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.actionErrorSubject.send(error)
                }
            }, receiveValue: { [weak self] in self?.wordDetailSubject.send($0) })
            .store(in: &cancellables)
    }


    private func toggleBookmark(phraseId: Int, isBookmarked: Bool) {
        toggleBookmarkUseCase.execute(phraseId: phraseId, isBookmarked: isBookmarked)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.updateBookmarkState(phraseId: phraseId, isBookmarked: isBookmarked)
                case .failure(let error):
                    self?.actionErrorSubject.send(error)
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

    private func fetchStudyWords() {
        let allWords = wordListSubject.value.flatMap { $0.items }
        studyWordsSubject.send(allWords)
    }
}
