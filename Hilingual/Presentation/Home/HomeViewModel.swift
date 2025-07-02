//
//  HomeViewModel.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Combine

final class HomeViewModel: BaseViewModel {

    // MARK: - Input

    struct Input {
        let fetchButtonTapped: AnyPublisher<Void, Never>
    }

    // MARK: - Output

    struct Output {
        let rateText: AnyPublisher<String, Never>
        let errorMessage: AnyPublisher<String, Never>
    }

    // MARK: - Properties

    private let useCase: HomeUseCase

    private let rateSubject = PassthroughSubject<String, Never>()
    private let errorSubject = PassthroughSubject<String, Never>()

    init(useCase: HomeUseCase) {
        self.useCase = useCase
    }

    // MARK: - Transform

    func transform(input: Input) -> Output {
        input.fetchButtonTapped
            .sink { [weak self] _ in
                guard let self = self else { return }

                self.useCase.fetchCurrentRate()
                    .sink(receiveCompletion: { [weak self] completion in
                        switch completion {
                        case .failure(let error):
                            self?.errorSubject.send("조회 실패: \(error.localizedDescription)")
                        case .finished:
                            break
                        }
                    }, receiveValue: { [weak self] entity in
                        let rateString = "1 USD = \(entity.exchangeRate) KRW"
                        self?.rateSubject.send(rateString)
                    })
                    .store(in: &self.cancellables)
            }
            .store(in: &cancellables)

        return Output(
            rateText: rateSubject.eraseToAnyPublisher(),
            errorMessage: errorSubject.eraseToAnyPublisher()
        )
    }
}

