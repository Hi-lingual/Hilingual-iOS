//
//  VocaViewModel.swift
//  HilingualPresentation
//
//  Created by 진소은 on 7/11/25.
//

import Combine
import HilingualDomain

public final class VocaViewModel: BaseViewModel {
    
    // MARK: - Input
    
    public struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
    }

    // MARK: - Output

    public struct Output {
        let fetchVoca: AnyPublisher<[RecommendedVocaEntity.Phrase], Never>
        let errorMessage: AnyPublisher<String, Never>
    }

    // MARK: - Properties

    private let recommendedVocaUseCase: RecommendedUseCase

    private let recommendecVocaSubject = PassthroughSubject<[RecommendedVocaEntity.Phrase], Never>()
    private let errorSubject = PassthroughSubject<String, Never>()

    public init(recommendedVocaUseCase: RecommendedUseCase) {
        self.recommendedVocaUseCase = recommendedVocaUseCase
    }

    public func transform(input: Input) -> Output {
        input.viewDidLoad
            .sink { [weak self] in
                guard let self = self else { return }

                self.recommendedVocaUseCase.fetchRecommendedVoca(diaryId: 29)
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

        return Output(
            fetchVoca: recommendecVocaSubject.eraseToAnyPublisher(),
            errorMessage: errorSubject.eraseToAnyPublisher()
        )
    }
}
