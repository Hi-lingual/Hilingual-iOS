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
        let userProfileImage: AnyPublisher<String?, Never>
    }
    
    // MARK: - Dependencies
    
    private let feedUseCase: FeedUseCase
    private let publishDiaryUseCase: PublishDiaryUseCase
    private let toggleLikeUseCase: ToggleLikeUseCase
    private let homeUseCase: HomeUseCase
    private let type: FeedListType?
    
    // MARK: - State
    
    private let feedsSubject = CurrentValueSubject<[FeedModel], Never>([])
    private let haveFollowingSubject = CurrentValueSubject<Bool?, Never>(nil)
    private let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    private let errorSubject = CurrentValueSubject<String?, Never>(nil)
    private let publishSubject = PassthroughSubject<Bool, Never>()
    private let likeSubject = PassthroughSubject<(Int, Bool), Never>()
    private let userProfileImageSubject = CurrentValueSubject<String?, Never>(nil)

    // MARK: - Init
    
    public init(
        feedUseCase: FeedUseCase,
        publishDiaryUseCase: PublishDiaryUseCase,
        toggleLikeUseCase: ToggleLikeUseCase,
        homeUseCase: HomeUseCase,
        type: FeedListType? = nil
    ) {
        self.feedUseCase = feedUseCase
        self.publishDiaryUseCase = publishDiaryUseCase
        self.toggleLikeUseCase = toggleLikeUseCase
        self.homeUseCase = homeUseCase
        self.type = type
        super.init()
    }
    
    // MARK: - Transform
    
    public func transform(input: Input) -> Output {
        let trigger = Publishers.Merge(viewDidLoad, input.reload.eraseToAnyPublisher())
        
        trigger
            .flatMap { [weak self] _ -> AnyPublisher<String?, Never> in
                guard let self else { return Just(nil).eraseToAnyPublisher() }
                return self.fetchUserProfileImage()
            }
            .sink { [weak self] url in
                self?.userProfileImageSubject.send(url)
            }
            .store(in: &cancellables)
        
        if let type = type {
            trigger
                .flatMap { [weak self] _ -> AnyPublisher<[FeedModel], Never> in
                    guard let self else { return Just([]).eraseToAnyPublisher() }
                    return self.fetchFeeds(type: type)
                }
                .sink { [weak self] items in
                    self?.feedsSubject.send(items)
                }
                .store(in: &cancellables)
        }
        
        input.unpublish
            .sink { [weak self] diaryId in
                _ = self?.unpublishDiary(diaryId: diaryId)
            }
            .store(in: &cancellables)
        
        input.likeTapped
            .sink { [weak self] (diaryId, isLiked) in
                _ = self?.toggleLike(diaryId: diaryId, isLiked: isLiked)
            }
            .store(in: &cancellables)

        return Output(
            feeds: feedsSubject.eraseToAnyPublisher(),
            haveFollowing: haveFollowingSubject.eraseToAnyPublisher(),
            isLoading: isLoadingSubject.eraseToAnyPublisher(),
            errorMessage: errorSubject.eraseToAnyPublisher(),
            publishResult: publishSubject.eraseToAnyPublisher(),
            likeResult: likeSubject.eraseToAnyPublisher(),
            userProfileImage: userProfileImageSubject.eraseToAnyPublisher()
        )
    }
    
    // MARK: - Public Methods
    
    public func fetchFeeds(type: FeedListType) -> AnyPublisher<[FeedModel], Never> {
        isLoadingSubject.send(true)
        errorSubject.send(nil)
        
        let useCaseType: FeedType = (type == .recommended) ? .recommend : .following
        
        return feedUseCase.execute(type: useCaseType)
            .map { [weak self] (entities, haveFollowing) -> [FeedModel] in
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
                    self?.haveFollowingSubject.send(haveFollowing ?? false)
                } else {
                    self?.haveFollowingSubject.send(nil)
                }
                return items
            }
            .handleEvents(receiveCompletion: { [weak self] _ in
                self?.isLoadingSubject.send(false)
            })
            .catch { [weak self] error in
                self?.errorSubject.send("피드 불러오기 실패: \(error.localizedDescription)")
                return Just<[FeedModel]>([])
            }
            .eraseToAnyPublisher()
    }
    
    public func fetchUserProfileImage() -> AnyPublisher<String?, Never> {
        return homeUseCase.fetchUserInfo()
            .map { userInfo in
                return userInfo.profileImg
            }
            .catch { [weak self] error -> Just<String?> in
                self?.errorSubject.send("프로필 이미지 불러오기 실패: \(error.localizedDescription)")
                return Just(nil)
            }
            .eraseToAnyPublisher()
    }
    
    public func publishDiary(diaryId: Int) -> AnyPublisher<Bool, Never> {
        return publishDiaryUseCase.publishDiary(diaryId: diaryId)
            .map { _ in true }
            .catch { [weak self] error -> Just<Bool> in
                self?.errorSubject.send("공개 실패: \(error.localizedDescription)")
                return Just(false)
            }
            .eraseToAnyPublisher()
    }

    public func unpublishDiary(diaryId: Int) -> AnyPublisher<Bool, Never> {
        return publishDiaryUseCase.unpublishDiary(diaryId: diaryId)
            .map { _ in false }
            .catch { [weak self] error -> Just<Bool> in
                self?.errorSubject.send("비공개 실패: \(error.localizedDescription)")
                return Just(false)
            }
            .handleEvents(receiveOutput: { [weak self] result in
                self?.publishSubject.send(result)
            })
            .eraseToAnyPublisher()
    }
    
    public func toggleLike(diaryId: Int, isLiked: Bool) -> AnyPublisher<(Int, Bool), Never> {
        return toggleLikeUseCase.toggleLike(diaryId: diaryId, isLiked: isLiked)
            .map { _ in (diaryId, !isLiked) }
            .catch { [weak self] error -> Just<(Int, Bool)> in
                self?.errorSubject.send("공감하기 실패: \(error.localizedDescription)")
                return Just((diaryId, isLiked))
            }
            .handleEvents(receiveOutput: { [weak self] result in
                self?.likeSubject.send(result)
            })
            .eraseToAnyPublisher()
    }
}
