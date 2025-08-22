//
//  FollowingFeedViewModel.swift
//  HilingualPresentation
//
//  Created by 조영서 on 8/20/25.
//


import Foundation
import Combine
import HilingualDomain

public final class FollowingFeedViewModel: BaseViewModel, BaseViewModelType {
    
    // MARK: - Input/Output
    public struct Input {
        /// 당겨서 새로고침 / 초기 로드 트리거
        let reload = PassthroughSubject<Void, Never>()
    }
    
    public struct Output {
        let feeds: AnyPublisher<([FeedDiaryItem], Bool), Never>
        let isLoading: AnyPublisher<Bool, Never>
        let errorMessage: AnyPublisher<String?, Never>
    }
    
    // MARK: - Dependencies
    private let feedUseCase: FeedUseCase
    
    // MARK: - State
    private let feedsSubject = CurrentValueSubject<([FeedDiaryItem], Bool), Never>(([], false))
    private let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    private let errorSubject = CurrentValueSubject<String?, Never>(nil)
    
    // MARK: - Init
    public init(feedUseCase: FeedUseCase) {
        self.feedUseCase = feedUseCase
        super.init()
    }
    
    // MARK: - Transform
    public func transform(input: Input) -> Output {
        let trigger = Publishers.Merge(
            viewDidLoad.eraseToAnyPublisher(),
            input.reload.eraseToAnyPublisher()
        )
            .eraseToAnyPublisher()
        
        trigger
            .flatMap { [weak self] _ -> AnyPublisher<([FeedDiaryItem], Bool), Never> in
                guard let self else { return Just(([], false)).eraseToAnyPublisher() }
                self.isLoadingSubject.send(true)
                self.errorSubject.send(nil)
                
                return self.feedUseCase.execute(type: .following)
                    .map { (entities, haveFollowing) -> ([FeedDiaryItem], Bool) in
                        let items = entities.map { e in
                            FeedDiaryItem(
                                id: e.diary.diaryId,
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
                        return (items, haveFollowing ?? false)
                    }
                    .handleEvents(receiveCompletion: { [weak self] _ in
                        self?.isLoadingSubject.send(false)
                    })
                    .catch { [weak self] error -> AnyPublisher<([FeedDiaryItem], Bool), Never> in
                        self?.errorSubject.send(error.localizedDescription)
                        return Just(([], false))
                            .eraseToAnyPublisher()
                    }
                    .eraseToAnyPublisher()
            }
            .sink { [weak self] (result: ([FeedDiaryItem], Bool)) in
                self?.feedsSubject.send(result)
            }
            .store(in: &cancellables)
        
        return Output(
            feeds: feedsSubject.eraseToAnyPublisher(),
            isLoading: isLoadingSubject.eraseToAnyPublisher(),
            errorMessage: errorSubject.eraseToAnyPublisher()
        )
    }
}
