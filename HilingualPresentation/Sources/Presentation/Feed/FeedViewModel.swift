//
//  FeedViewModel.swift
//  HilingualPresentation
//
//  Created by 조영서 on 8/18/25.
//

import Combine
import Foundation
import HilingualDomain

public enum FeedListType {
    case recommended
    case following
}

public final class FeedViewModel: BaseViewModel, BaseViewModelType {
    
    // MARK: - Input/Output
    
    public struct Input {
        let reload = PassthroughSubject<Void, Never>()
        let unpublish = PassthroughSubject<Int, Never>()
        let likeTapped = PassthroughSubject<(Int, Bool), Never>()
    }

    public struct Output {
        let feeds: AnyPublisher<[FeedModel], Never>
        let haveFollowing: AnyPublisher<Bool?, Never>
        let isLoading: AnyPublisher<Bool, Never>
        let errorMessage: AnyPublisher<String?, Never>
        let publishResult: AnyPublisher<Bool, Never>
        let likeResult: AnyPublisher<(Int, Bool), Never>
    }
    
    // MARK: - Dependencies
    
    private let feedUseCase: FeedUseCase
    private let publishDiaryUseCase: PublishDiaryUseCase
    private let toggleLikeUseCase: ToggleLikeUseCase
    private let type: FeedListType?
    
    // MARK: - State
    
    private let feedsSubject = CurrentValueSubject<[FeedModel], Never>([])
    private let haveFollowingSubject = CurrentValueSubject<Bool?, Never>(nil)
    private let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    private let errorSubject = CurrentValueSubject<String?, Never>(nil)
    private let publishSubject = PassthroughSubject<Bool, Never>()
    private let likeSubject = PassthroughSubject<(Int, Bool), Never>()
    
    // MARK: - Init
    
    public init(
        feedUseCase: FeedUseCase,
        publishDiaryUseCase: PublishDiaryUseCase,
        toggleLikeUseCase: ToggleLikeUseCase,
        type: FeedListType? = nil
    ) {
        self.feedUseCase = feedUseCase
        self.publishDiaryUseCase = publishDiaryUseCase
        self.toggleLikeUseCase = toggleLikeUseCase
        self.type = type
        super.init()
    }
    
    // MARK: - Transform
    
    public func transform(input: Input) -> Output {
        if let type = type {
            let trigger = Publishers.Merge(viewDidLoad, input.reload.eraseToAnyPublisher())
            
            trigger
                .flatMap { [weak self] _ -> AnyPublisher<[FeedModel], Never> in
                    guard let self else { return Just([]).eraseToAnyPublisher() }
                    self.isLoadingSubject.send(true)
                    self.errorSubject.send(nil)
                    
                    let useCaseType: FeedType = (type == .recommended) ? .recommend : .following
                    
                    return self.feedUseCase.execute(type: useCaseType)
                        .map { (entities, haveFollowing) -> [FeedModel] in
                            let items = entities.map { e in
                                FeedModel(
                                    diaryID: e.diary.diaryId,
                                    userID: e.profile.userId,
                                    nickname: e.profile.nickname,
                                    profileImg: e.profile.profileImg,
                                    isMine: e.profile.isMine,
                                    streak: e.profile.streak,
                                    sharedDateMinutes: e.diary.sharedDate,
                                    diaryPreviewText: e.diary.originalText,
                                    diaryImageUrl: e.diary.diaryImg,
                                    isLiked: e.diary.isLiked,
                                    likeCount: e.diary.likeCount
                                )
                            }
                            
                            if type == .following {
                                self.haveFollowingSubject.send(haveFollowing ?? false)
                            } else {
                                self.haveFollowingSubject.send(nil)
                            }
                            
                            return items
                        }
                        .handleEvents(receiveCompletion: { [weak self] _ in
                            self?.isLoadingSubject.send(false)
                        })
                        .catch { [weak self] error in
                            self?.errorSubject.send(error.localizedDescription)
                            return Just<[FeedModel]>([])
                        }
                        .eraseToAnyPublisher()
                }
                .sink { [weak self] items in
                    self?.feedsSubject.send(items)
                }
                .store(in: &cancellables)
        }
        
        input.unpublish
            .sink { [weak self] diaryId in
                self?.unpublishDiary(diaryId: diaryId)
            }
            .store(in: &cancellables)
        
        input.likeTapped
            .sink { [weak self] (diaryId, isLiked) in
                self?.toggleLike(diaryId: diaryId, isLiked: isLiked)
            }
            .store(in: &cancellables)
        
        return Output(
            feeds: feedsSubject.eraseToAnyPublisher(),
            haveFollowing: haveFollowingSubject.eraseToAnyPublisher(),
            isLoading: isLoadingSubject.eraseToAnyPublisher(),
            errorMessage: errorSubject.eraseToAnyPublisher(),
            publishResult: publishSubject.eraseToAnyPublisher(),
            likeResult: likeSubject.eraseToAnyPublisher()

        )
    }
    
    // MARK: - Private

    private func unpublishDiary(diaryId: Int) {
        publishDiaryUseCase.unpublishDiary(diaryId: diaryId)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.errorSubject.send("공개 상태 변경 실패: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] _ in
                self?.publishSubject.send(false)
            })
            .store(in: &cancellables)
    }
    
    private func toggleLike(diaryId: Int, isLiked: Bool) {
        toggleLikeUseCase.toggleLike(diaryId: diaryId, isLiked: isLiked)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.errorSubject.send("공감하기 실패: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] _ in
                self?.likeSubject.send((diaryId, !isLiked))
            })
            .store(in: &cancellables)
    }
}

