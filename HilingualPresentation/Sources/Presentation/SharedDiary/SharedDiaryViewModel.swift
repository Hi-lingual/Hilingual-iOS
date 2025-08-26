//
//  SharedDiaryViewModel.swift
//  HilingualPresentation
//
//  Created by 진소은 on 8/21/25.
//

import Combine

import HilingualDomain

public final class SharedDiaryViewModel: BaseViewModel {
    
    let diaryId: Int
    
    // MARK: - Input
    
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let likeTapped: AnyPublisher<(Int,Bool), Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let fetchDiaryResult: AnyPublisher<SharedDiaryEntity, Never>
        let errorMessage: AnyPublisher<String, Never>
    }
    
    // MARK: - Properties
    
    private let sharedDiaryUseCase: SharedDiaryUseCase
    private let toggleLikeUseCase: ToggleLikeUseCase
    
    private let sharedDiarySubject = PassthroughSubject<SharedDiaryEntity, Never>()
    private let errorSubject = PassthroughSubject<String, Never>()
    
    public init(diaryId: Int,
                sharedDiaryUseCase: SharedDiaryUseCase, toggleLikeUseCase: ToggleLikeUseCase) {
        self.diaryId = diaryId
        self.sharedDiaryUseCase = sharedDiaryUseCase
        self.toggleLikeUseCase = toggleLikeUseCase
    }
    
    func transform(input: Input) -> Output {
        input.viewDidLoad
            .sink { [weak self] in
                guard let self = self else { return }
                self.sharedDiaryUseCase.fetchSharedDiary(diaryId: diaryId)
                    .sink(receiveCompletion: { [weak self] completion in
                        switch completion {
                        case .failure(let error):
                            self?.errorSubject.send("\(error)")
                        case .finished:
                            break
                        }
                    }, receiveValue: { [weak self] entity in
                        let sharedDiaryData = entity
                        self?.sharedDiarySubject.send(sharedDiaryData)
                    })
                    .store(in: &self.cancellables)
                
            }
            .store(in: &cancellables)
        input.likeTapped
                    .sink { [weak self] (diaryId, isLiked) in
                        self?.toggleLike(diaryId: diaryId, isLiked: isLiked)
                    }
                    .store(in: &cancellables)
        
        return Output(
            fetchDiaryResult: sharedDiarySubject.eraseToAnyPublisher(),
            errorMessage: errorSubject.eraseToAnyPublisher()
        )
    }
    
    private func toggleLike(diaryId: Int, isLiked: Bool) {
        toggleLikeUseCase.toggleLike(diaryId: diaryId, isLiked: isLiked)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.errorSubject.send("공감하기 실패: \(error.localizedDescription)")
                }
            }, receiveValue: { _ in

            })
            .store(in: &cancellables)
    }

}
