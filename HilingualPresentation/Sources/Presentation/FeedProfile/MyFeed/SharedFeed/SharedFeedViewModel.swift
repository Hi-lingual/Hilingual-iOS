//
//  SharedFeedViewModel.swift
//  HilingualPresentation
//
//  Created by 조영서 on 8/22/25.
//

import Foundation
import Combine
import HilingualDomain

public final class SharedFeedViewModel: BaseViewModel, BaseViewModelType {

    // MARK: - Input/Output
    public struct Input {
        /// 당겨서 새로고침 / 초기 로드 트리거
        let reload = PassthroughSubject<Void, Never>()
    }

    public struct Output {
        let feeds: AnyPublisher<[FeedProfileDiaryItem], Never>
        let isLoading: AnyPublisher<Bool, Never>
        let errorMessage: AnyPublisher<String?, Never>
        let isEmpty: AnyPublisher<Bool, Never>
    }
    
    // MARK: - Dependencies
    private let feedUseCase: FeedProfileUseCase

    // MARK: - State
    private let feedsSubject = CurrentValueSubject<[FeedProfileDiaryItem], Never>([])
    private let isEmptySubject = CurrentValueSubject<Bool, Never>(false)
    private let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    private let errorSubject = CurrentValueSubject<String?, Never>(nil)

    // MARK: - Init
    public init(feedUseCase: FeedProfileUseCase) {
        self.feedUseCase = feedUseCase
        super.init()
    }

    // MARK: - Transform
    public func transform(input: Input) -> Output {
        let trigger = Publishers.Merge(viewDidLoad, input.reload.eraseToAnyPublisher())
            .eraseToAnyPublisher()

        trigger
            .flatMap { [weak self] _ -> AnyPublisher<[FeedProfileDiaryItem], Never> in
                guard let self else { return Just([]).eraseToAnyPublisher() }
                self.isLoadingSubject.send(true)
                self.errorSubject.send(nil)

                return self.feedUseCase.execute(type: .shared, targetUserId: 0)
                    .map { (entities, _) -> [FeedProfileDiaryItem] in
                        entities.map { entity in
                            FeedProfileDiaryItem(
                                id: entity.diary.diaryId,
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
                        return Just<[FeedProfileDiaryItem]>([])
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
            isLoading: isLoadingSubject.eraseToAnyPublisher(),
            errorMessage: errorSubject.eraseToAnyPublisher(),
            isEmpty: isEmptySubject.eraseToAnyPublisher()
        )
    }
}
