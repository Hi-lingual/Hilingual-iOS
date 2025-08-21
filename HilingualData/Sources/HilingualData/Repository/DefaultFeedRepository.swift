//
//  DefaultFeedRepository.swift
//  HilingualData
//
//  Created by 조영서 on 8/20/25.
//

import Combine
import HilingualDomain
import HilingualNetwork

public final class DefaultFeedRepository: FeedRepository {

    private let service: FeedService

    public init(service: FeedService) {
        self.service = service
    }

    public func fetch(type: FeedType) -> AnyPublisher<[FeedEntity], Error> {
        switch type {
        case .recommended:
            return service.fetchRecommendedFeed()
                .map { dto in
                    dto.data.diaryList.map { item in
                        FeedEntity(
                            profile: FeedProfile(
                                userId: item.profile.userId,
                                isMine: item.profile.isMine,
                                profileImg: item.profile.profileImg,
                                nickname: item.profile.nickname,
                                streak: item.profile.streak
                            ),
                            diary: FeedDiary(
                                diaryId: item.diary.diaryId,
                                sharedDate: item.diary.sharedDate,
                                likeCount: item.diary.likeCount,
                                isLiked: item.diary.isLiked,
                                diaryImg: item.diary.diaryImg,
                                originalText: item.diary.originalText
                            )
                        )
                    }
                }
                .eraseToAnyPublisher()

        case .following:
            return service.fetchFollowingFeed()
                .map { dto in
                    dto.data.diaryList.map { item in
                        FeedEntity(
                            profile: FeedProfile(
                                userId: item.profile.userId,
                                isMine: item.profile.isMine,
                                profileImg: item.profile.profileImg,
                                nickname: item.profile.nickname,
                                streak: item.profile.streak
                            ),
                            diary: FeedDiary(
                                diaryId: item.diary.diaryId,
                                sharedDate: item.diary.sharedDate,
                                likeCount: item.diary.likeCount,
                                isLiked: item.diary.isLiked,
                                diaryImg: item.diary.diaryImg,
                                originalText: item.diary.originalText
                            )
                        )
                    }
                }
                .eraseToAnyPublisher()
        }
    }
}
