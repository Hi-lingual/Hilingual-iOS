//
//  RecommendFeedViewModel.swift
//  HilingualPresentation
//
//  Created by 조영서 on 8/20/25.
//

import Foundation
import Combine
import HilingualDomain

public final class RecommendFeedViewModel: BaseViewModel, BaseViewModelType {

    // MARK: - Input/Output
    public struct Input {
        /// 당겨서 새로고침 / 초기 로드 트리거
        let reload = PassthroughSubject<Void, Never>()
    }

    public struct Output {
        let feeds: AnyPublisher<[FeedDiaryItem], Never>
        let isLoading: AnyPublisher<Bool, Never>
        let errorMessage: AnyPublisher<String?, Never>
    }
    
    // MARK: - Dependencies
    private let feedUseCase: FeedUseCase

    // MARK: - State
    private let feedsSubject = CurrentValueSubject<[FeedDiaryItem], Never>([])
    private let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    private let errorSubject = CurrentValueSubject<String?, Never>(nil)

    // MARK: - Init
    public init(feedUseCase: FeedUseCase) {
        self.feedUseCase = feedUseCase
        super.init()
    }

    // MARK: - Transform
    public func transform(input: Input) -> Output {
        let trigger = Publishers.Merge(viewDidLoad, input.reload.eraseToAnyPublisher())
            .eraseToAnyPublisher()

        trigger
            .flatMap { [weak self] _ -> AnyPublisher<[FeedDiaryItem], Never> in
                guard let self else { return Just([]).eraseToAnyPublisher() }
                self.isLoadingSubject.send(true)
                self.errorSubject.send(nil)

                return self.feedUseCase.execute(type: .recommended)
                    .map { (entities, _) -> [FeedDiaryItem] in
                        entities.map { entity in
                            FeedDiaryItem(
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
                        return Just<[FeedDiaryItem]>([])
                    }
                    .eraseToAnyPublisher()
            }
            .sink { [weak self] items in
                self?.feedsSubject.send(items)
            }
            .store(in: &cancellables)

        return Output(
            feeds: feedsSubject.eraseToAnyPublisher(),
            isLoading: isLoadingSubject.eraseToAnyPublisher(),
            errorMessage: errorSubject.eraseToAnyPublisher()
        )
    }
}
