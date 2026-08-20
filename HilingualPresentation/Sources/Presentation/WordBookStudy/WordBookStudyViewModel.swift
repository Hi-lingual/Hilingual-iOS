//
//  WordBookStudyViewModel.swift
//  HilingualPresentation
//
//  Created by 진소은 on 8/18/26.
//

import Combine
import HilingualDomain

public final class WordBookStudyViewModel: BaseViewModel {

    // MARK: - Input / Output

    public struct Input {
        let cardSwiped: AnyPublisher<(phraseId: Int64, isMemorized: Bool), Never>
        let submitTapped: AnyPublisher<Void, Never>
        let retryRequested: AnyPublisher<Void, Never>
    }

    public struct Output {
        let submitSucceeded: AnyPublisher<Void, Never>
        let actionError: AnyPublisher<Error, Never>
        let isSubmitting: AnyPublisher<Bool, Never>
    }

    // MARK: - Dependencies

    private let useCase: WordBookUseCase

    // MARK: - State

    private var memorizedResults: [Int64: Bool] = [:]
    var hasAnyResult: Bool { !memorizedResults.isEmpty }

    // MARK: - Subjects

    private let submitSucceededSubject = PassthroughSubject<Void, Never>()
    private let actionErrorSubject = PassthroughSubject<Error, Never>()
    private let isSubmittingSubject = CurrentValueSubject<Bool, Never>(false)

    // MARK: - Init

    public init(useCase: WordBookUseCase) {
        self.useCase = useCase
        super.init()
    }

    // MARK: - Transform

    public func transform(input: Input) -> Output {
        input.cardSwiped
            .sink { [weak self] phraseId, isMemorized in
                self?.memorizedResults[phraseId] = isMemorized
            }
            .store(in: &cancellables)

        input.submitTapped
            .sink { [weak self] in
                self?.submit()
            }
            .store(in: &cancellables)

        input.retryRequested
            .sink { [weak self] in
                self?.submit()
            }
            .store(in: &cancellables)

        return Output(
            submitSucceeded: submitSucceededSubject.eraseToAnyPublisher(),
            actionError: actionErrorSubject.eraseToAnyPublisher(),
            isSubmitting: isSubmittingSubject.eraseToAnyPublisher()
        )
    }

    // MARK: - Private

    private func submit() {
        let items = memorizedResults.map {
            MemorizationEntity(phraseId: Int($0.key), isMemorized: $0.value)
        }
        guard !items.isEmpty else {
            submitSucceededSubject.send(())
            return
        }

        isSubmittingSubject.send(true)

        useCase.updateMemorization(items: items)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isSubmittingSubject.send(false)
                if case .failure(let error) = completion {
                    self?.actionErrorSubject.send(error)
                }
            }, receiveValue: { [weak self] in
                self?.submitSucceededSubject.send(())
            })
            .store(in: &cancellables)
    }
}
