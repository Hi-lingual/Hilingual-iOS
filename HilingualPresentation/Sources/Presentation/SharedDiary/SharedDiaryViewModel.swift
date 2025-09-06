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
        let publishTapped: AnyPublisher<Int, Never>
        let unpublishTapped: AnyPublisher<Int, Never>
        let blockTapped: AnyPublisher<Int64, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let fetchDiaryResult: AnyPublisher<SharedDiaryEntity, Never>
        let errorMessage: AnyPublisher<String, Never>
    }
    
    // MARK: - Properties
    
    private let sharedDiaryUseCase: SharedDiaryUseCase
    private let toggleLikeUseCase: ToggleLikeUseCase
    private let publishDiaryUseCase: PublishDiaryUseCase
    private let blockUserUseCase: BlockUserUseCase
    
    private let sharedDiarySubject = PassthroughSubject<SharedDiaryEntity, Never>()
    private let errorSubject = PassthroughSubject<String, Never>()
    
    public init(diaryId: Int,
                sharedDiaryUseCase: SharedDiaryUseCase, toggleLikeUseCase: ToggleLikeUseCase, publishDiaryUseCase: PublishDiaryUseCase, blockUserUseCase: BlockUserUseCase) {
        self.diaryId = diaryId
        self.sharedDiaryUseCase = sharedDiaryUseCase
        self.toggleLikeUseCase = toggleLikeUseCase
        self.publishDiaryUseCase = publishDiaryUseCase
        self.blockUserUseCase = blockUserUseCase
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
        
        input.publishTapped
            .sink { [weak self] diaryId in
                self?.publishDiary(diaryId: diaryId)
            }
            .store(in: &cancellables)
        
        input.unpublishTapped
            .sink { [weak self] diaryId in
                self?.unpublishDiary(diaryId: diaryId)
            }
            .store(in: &cancellables)
        
        input.blockTapped
            .sink { [weak self] userId in
                self?.blockUser(userId: userId)
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
    
    private func publishDiary(diaryId: Int) {
        publishDiaryUseCase.publishDiary(diaryId: diaryId)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.errorSubject.send("공개 상태 변경 실패: \(error.localizedDescription)")
                }
            }, receiveValue: { _ in
                
            })
            .store(in: &cancellables)
    }
    
    private func unpublishDiary(diaryId: Int) {
        publishDiaryUseCase.unpublishDiary(diaryId: diaryId)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.errorSubject.send("비공개 전환 실패: \(error.localizedDescription)")
                }
            }, receiveValue: { _ in
                
            })
            .store(in: &cancellables)
    }
    
    private func blockUser(userId: Int64) {
        blockUserUseCase.blockUser(id: Int(userId))
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.errorSubject.send("차단 실패: \(error.localizedDescription)")
                }
            }, receiveValue: { _ in
                
            })
            .store(in: &cancellables)
    }
}
