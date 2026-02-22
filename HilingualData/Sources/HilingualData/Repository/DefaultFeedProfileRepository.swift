//
//  DefaultFeedProfileRepository.swift
//  HilingualData
//
//  Created by 조영서 on 8/22/25.
//

import Combine
import HilingualDomain
import HilingualNetwork

public final class DefaultFeedProfileRepository: FeedProfileRepository {

    private let service: FeedProfileService

    public init(service: FeedProfileService) {
        self.service = service
    }

    public func fetch(type: FeedProfileType, targetUserId: Int64) -> AnyPublisher<([FeedEntity], Bool?), Error> {
        switch type {
        case .shared: // 공유 피드
            return service.fetchSharedFeed(targetUserId: targetUserId)
                .map { dto in
                    let entities = dto.data.diaryList.map { item in
                        FeedEntity(
                            profile: FeedProfile(
                                userId: Int(targetUserId),
                                isMine: (targetUserId == 0),
                                profileImg: dto.data.profile.profileImg,
                                nickname: dto.data.profile.nickname,
                                streak: nil
                            ),
                            diary: FeedDiary(
                                diaryId: item.diaryId,
                                sharedDate: item.sharedDate,
                                likeCount: item.likeCount,
                                isLiked: item.isLiked,
                                diaryImg: item.diaryImg,
                                originalText: item.originalText
                            )
                        )
                    }
                    return (entities, nil)
                }
                .eraseToAnyPublisher()

        case .liked: // 공감 피드
            return service.fetchLikedFeed(targetUserId: targetUserId)
                .map { dto in
                    let entities = dto.data.diaryList.map { item in
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
                    return (entities, nil)
                }
                .eraseToAnyPublisher()
        }
    }
}
