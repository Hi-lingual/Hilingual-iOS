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
    }

    public struct Output {
        let feeds: AnyPublisher<[FeedModel], Never>
        let haveFollowing: AnyPublisher<Bool?, Never>
        let isLoading: AnyPublisher<Bool, Never>
        let errorMessage: AnyPublisher<String?, Never>
    }

    // MARK: - Dependencies
    
    private let feedUseCase: FeedUseCase
    private let type: FeedListType?

    // MARK: - State
    
    private let feedsSubject = CurrentValueSubject<[FeedModel], Never>([])
    private let haveFollowingSubject = CurrentValueSubject<Bool?, Never>(nil)
    private let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    private let errorSubject = CurrentValueSubject<String?, Never>(nil)

    // MARK: - Init
    //피드 리스트
    public init(feedUseCase: FeedUseCase, type: FeedListType) {
        self.feedUseCase = feedUseCase
        self.type = type
        super.init()
    }

    //피드 프로필
    public override init() {
        self.feedUseCase = DummyFeedUseCase()
        self.type = nil
        super.init()
    }

    // MARK: - Transform
    public func transform(input: Input) -> Output {
        guard let type else {
            return Output(
                feeds: feedsSubject.eraseToAnyPublisher(),
                haveFollowing: haveFollowingSubject.eraseToAnyPublisher(),
                isLoading: isLoadingSubject.eraseToAnyPublisher(),
                errorMessage: errorSubject.eraseToAnyPublisher()
            )
        }

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

        return Output(
            feeds: feedsSubject.eraseToAnyPublisher(),
            haveFollowing: haveFollowingSubject.eraseToAnyPublisher(),
            isLoading: isLoadingSubject.eraseToAnyPublisher(),
            errorMessage: errorSubject.eraseToAnyPublisher()
        )
    }
}

// MARK: - DummyFeedUseCase
private final class DummyFeedUseCase: FeedUseCase {
    func execute(type: FeedType) -> AnyPublisher<([FeedEntity], Bool?), Error> {
        return Just(([], nil))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

