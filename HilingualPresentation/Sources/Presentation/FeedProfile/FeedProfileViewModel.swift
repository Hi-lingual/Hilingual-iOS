//
//  FeedProfileViewModel.swift
//  HilingualPresentation
//
//  Created by 조영서 on 8/25/25.
//

import Foundation
import Combine
import HilingualDomain

public final class FeedProfileViewModel: BaseViewModel, BaseViewModelType {
    
    // MARK: - Input/Output
    
    public struct Input {
        let reload = PassthroughSubject<Void, Never>()
        let follow = PassthroughSubject<Void, Never>()
        let unfollow = PassthroughSubject<Void, Never>()
        let block = PassthroughSubject<Void, Never>()
        let unblock = PassthroughSubject<Void, Never>()
        let unpublish = PassthroughSubject<Int, Never>()
        let likeTapped = PassthroughSubject<(Int, Bool), Never>()
    }
    
    public struct Output {
        let feeds: AnyPublisher<[FeedModel], Never>
        let profile: AnyPublisher<FeedProfileInfoEntity?, Never>
        let isLoading: AnyPublisher<Bool, Never>
        let errorMessage: AnyPublisher<String?, Never>
        let isEmpty: AnyPublisher<Bool, Never>
        let buttonState: AnyPublisher<FollowButtonState?, Never>
        let publishResult: AnyPublisher<Bool, Never>
        let likeResult: AnyPublisher<(Int, Bool), Never>
    }
    
    // MARK: - Dependencies
    
    private let feedUseCase: FeedProfileUseCase
    private let profileInfoUseCase: FeedProfileInfoUseCase
    private let followUseCase: FollowListUseCase
    private let blockUserUseCase: BlockUserUseCase
    private let publishDiaryUseCase: PublishDiaryUseCase
    private let toggleLikeUseCase: ToggleLikeUseCase
    private let type: FeedProfileType
    public let targetUserId: Int64
    
    // MARK: - State
    
    private let feedsSubject = CurrentValueSubject<[FeedModel], Never>([])
    private let profileSubject = CurrentValueSubject<FeedProfileInfoEntity?, Never>(nil)
    private let isEmptySubject = CurrentValueSubject<Bool, Never>(false)
    private let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    private let errorSubject = CurrentValueSubject<String?, Never>(nil)
    private let buttonStateSubject = CurrentValueSubject<FollowButtonState?, Never>(nil)
    private let publishSubject = PassthroughSubject<Bool, Never>()
    private let likeSubject = PassthroughSubject<(Int, Bool), Never>()
    
    // MARK: - Init
    
    public init(
        feedUseCase: FeedProfileUseCase,
        profileInfoUseCase: FeedProfileInfoUseCase,
        followUseCase: FollowListUseCase,
        publishDiaryUseCase: PublishDiaryUseCase,
        toggleLikeUseCase: ToggleLikeUseCase,
        blockUserUseCase: BlockUserUseCase,
        type: FeedProfileType,
        targetUserId: Int64 = 0
    ) {
        self.feedUseCase = feedUseCase
        self.profileInfoUseCase = profileInfoUseCase
        self.followUseCase = followUseCase
        self.publishDiaryUseCase = publishDiaryUseCase
        self.toggleLikeUseCase = toggleLikeUseCase
        self.blockUserUseCase = blockUserUseCase
        self.type = type
        self.targetUserId = targetUserId
        super.init()
    }
    
    // MARK: - Transform
    
    public func transform(input: Input) -> Output {
        let trigger = Publishers.Merge(viewDidLoad, input.reload.eraseToAnyPublisher())
            .eraseToAnyPublisher()
        
        // 프로필 정보
        trigger
            .flatMap { [weak self] _ -> AnyPublisher<FeedProfileInfoEntity?, Never> in
                guard let self else { return Just(nil).eraseToAnyPublisher() }
                return self.profileInfoUseCase.execute(targetUserId: self.targetUserId)
                    .map { Optional($0) }
                    .catch { [weak self] error -> Just<FeedProfileInfoEntity?> in
                        self?.errorSubject.send(error.localizedDescription)
                        return Just(nil)
                    }
                    .eraseToAnyPublisher()
            }
            .sink { [weak self] entity in
                self?.profileSubject.send(entity)
                if let entity {
                    let state = self?.followButtonState(entity: entity)
                    self?.buttonStateSubject.send(state)
                }
            }
            .store(in: &cancellables)
        
        // 피드
        trigger
            .flatMap { [weak self] _ -> AnyPublisher<[FeedModel], Never> in
                guard let self else { return Just([]).eraseToAnyPublisher() }
                self.isLoadingSubject.send(true)
                self.errorSubject.send(nil)
                
                return self.feedUseCase.execute(type: self.type, targetUserId: self.targetUserId)
                    .map { (entities, _) -> [FeedModel] in
                        entities.map { entity in
                            FeedModel(
                                diaryID: entity.diary.diaryId,
                                userID: entity.profile.userId,
                                nickname: entity.profile.nickname,
                                profileImg: entity.profile.profileImg,
                                isMine: entity.profile.isMine,
                                streak: entity.profile.streak,
                                sharedDateMinutes: entity.diary.sharedDate,
                                diaryPreviewText: entity.diary.originalText,
                                diaryImageUrl: entity.diary.diaryImg,
                                isLiked: entity.diary.isLiked,
                                likeCount: entity.diary.likeCount
                            )
                        }
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
                self?.isEmptySubject.send(items.isEmpty)
            }
            .store(in: &cancellables)
        
        // 일기 비공개하기
        input.unpublish
            .sink { [weak self] diaryId in
                self?.unpublishDiary(diaryId: diaryId)
            }
            .store(in: &cancellables)
        
        // 공감하기
        input.likeTapped
            .sink { [weak self] (diaryId, isLiked) in
                self?.toggleLike(diaryId: diaryId, isLiked: isLiked)
            }
            .store(in: &cancellables)
        
        // 팔로우하기
        input.follow
            .flatMap { [weak self] _ -> AnyPublisher<Void, Never> in
                guard let self else { return Empty().eraseToAnyPublisher() }
                return self.followUseCase.follow(userId: Int(self.targetUserId))
                    .catch { [weak self] error -> Just<Void> in
                        self?.errorSubject.send("팔로우 실패: \(error.localizedDescription)")
                        return Just(())
                    }
                    .eraseToAnyPublisher()
            }
            .sink { [weak self] _ in
                self?.buttonStateSubject.send(.following)
            }
            .store(in: &cancellables)
        
        // 팔로우 해제하기
        input.unfollow
            .flatMap { [weak self] _ -> AnyPublisher<Bool, Never> in
                guard let self else { return Empty().eraseToAnyPublisher() }
                return self.followUseCase.unfollow(userId: Int(self.targetUserId))
                    .catch { [weak self] error -> Just<Bool> in
                        self?.errorSubject.send("언팔로우 실패: \(error.localizedDescription)")
                        return Just(false)
                    }
                    .eraseToAnyPublisher()
            }
            .sink { [weak self] success in
                if success {
                    self?.reloadProfile()
                }
            }
            .store(in: &cancellables)
        
        // 차단하기
        input.block
            .flatMap { [weak self] _ -> AnyPublisher<Void, Never> in
                guard let self else { return Empty().eraseToAnyPublisher() }
                return self.blockUserUseCase.blockUser(id: Int(self.targetUserId))
                    .catch { [weak self] error -> Just<Void> in
                        self?.errorSubject.send("차단 실패: \(error.localizedDescription)")
                        return Just(())
                    }
                    .eraseToAnyPublisher()
            }
            .sink { [weak self] _ in
                self?.buttonStateSubject.send(.unblock)
            }
            .store(in: &cancellables)
        
        // 차단 해제하기
        input.unblock
            .flatMap { [weak self] _ -> AnyPublisher<Void, Never> in
                guard let self else { return Empty().eraseToAnyPublisher() }
                return self.blockUserUseCase.unblockUser(id: Int(self.targetUserId))
                    .catch { [weak self] error -> Just<Void> in
                        self?.errorSubject.send("차단 해제 실패: \(error.localizedDescription)")
                        return Just(())
                    }
                    .eraseToAnyPublisher()
            }
            .sink { [weak self] _ in
                self?.buttonStateSubject.send(.follow)
            }
            .store(in: &cancellables)
        
        return Output(
            feeds: feedsSubject.eraseToAnyPublisher(),
            profile: profileSubject.eraseToAnyPublisher(),
            isLoading: isLoadingSubject.eraseToAnyPublisher(),
            errorMessage: errorSubject.eraseToAnyPublisher(),
            isEmpty: isEmptySubject.eraseToAnyPublisher(),
            buttonState: buttonStateSubject.eraseToAnyPublisher(),
            publishResult: publishSubject.eraseToAnyPublisher(),
            likeResult: likeSubject.eraseToAnyPublisher()
        )
    }
    
    // MARK: - Private
    
    private func reloadProfile() {
        profileInfoUseCase.execute(targetUserId: targetUserId)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorSubject.send(error.localizedDescription)
                }
            }, receiveValue: { [weak self] entity in
                self?.profileSubject.send(entity)
                let state = self?.followButtonState(entity: entity)
                self?.buttonStateSubject.send(state)
            })
            .store(in: &cancellables)
    }
    
    private func followButtonState(entity: FeedProfileInfoEntity) -> FollowButtonState? {
        let isMine = entity.isMine
        let isBlocked = entity.isBlocked ?? false
        let isFollowing = entity.isFollowing ?? false
        let isFollowed = entity.isFollowed ?? false
        
        if isMine { return nil }
        if isBlocked { return .unblock }
        if isFollowing && isFollowed { return .following }
        if isFollowing { return .following }
        if isFollowed { return .mutualFollow }
        return .follow
    }
    
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
