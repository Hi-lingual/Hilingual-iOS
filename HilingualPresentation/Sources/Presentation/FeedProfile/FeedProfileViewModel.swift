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
        /// 당겨서 새로고침 / 초기 로드 트리거
        let reload = PassthroughSubject<Void, Never>()
    }
    
    public struct Output {
        let feeds: AnyPublisher<[FeedDiaryItem], Never>
        let profile: AnyPublisher<FeedProfileInfoEntity?, Never>
        let isLoading: AnyPublisher<Bool, Never>
        let errorMessage: AnyPublisher<String?, Never>
        let isEmpty: AnyPublisher<Bool, Never>
    }
    
    // MARK: - Dependencies
    private let feedUseCase: FeedProfileUseCase
    private let profileInfoUseCase: FeedProfileInfoUseCase
    private let type: FeedProfileType
    private let targetUserId: Int64
    
    // MARK: - State
    private let feedsSubject = CurrentValueSubject<[FeedDiaryItem], Never>([])
    private let profileSubject = CurrentValueSubject<FeedProfileInfoEntity?, Never>(nil)
    private let isEmptySubject = CurrentValueSubject<Bool, Never>(false)
    private let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    private let errorSubject = CurrentValueSubject<String?, Never>(nil)
    
    // MARK: - Init
    public init(feedUseCase: FeedProfileUseCase,
                profileInfoUseCase: FeedProfileInfoUseCase,
                type: FeedProfileType,
                targetUserId: Int64 = 0) {
        self.feedUseCase = feedUseCase
        self.profileInfoUseCase = profileInfoUseCase
        self.type = type
        self.targetUserId = targetUserId
        super.init()
    }
    
    // MARK: - Transform
    public func transform(input: Input) -> Output {
        let trigger = Publishers.Merge(viewDidLoad, input.reload.eraseToAnyPublisher())
            .eraseToAnyPublisher()
        
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
            }
            .store(in: &cancellables)
        
        trigger
            .flatMap { [weak self] _ -> AnyPublisher<[FeedDiaryItem], Never> in
                guard let self else { return Just([]).eraseToAnyPublisher() }
                self.isLoadingSubject.send(true)
                self.errorSubject.send(nil)
                
                return self.feedUseCase.execute(type: self.type, targetUserId: self.targetUserId)
                    .map { (entities, _) -> [FeedDiaryItem] in
                        entities.map { entity in
                            FeedDiaryItem(
                                id: entity.diary.diaryId,
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
                        return Just<[FeedDiaryItem]>([])
                    }
                    .eraseToAnyPublisher()
            }
            .sink { [weak self] items in
                self?.feedsSubject.send(items)
                self?.isEmptySubject.send(items.isEmpty)
            }
            .store(in: &cancellables)
        
        return Output(
            feeds: feedsSubject.eraseToAnyPublisher(),
            profile: profileSubject.eraseToAnyPublisher(),
            isLoading: isLoadingSubject.eraseToAnyPublisher(),
            errorMessage: errorSubject.eraseToAnyPublisher(),
            isEmpty: isEmptySubject.eraseToAnyPublisher()
        )
    }
}
