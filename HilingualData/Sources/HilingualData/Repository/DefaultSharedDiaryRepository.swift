//
//  DefaultSharedDiaryRepository.swift
//  HilingualData
//
//  Created by 진소은 on 8/26/25.
//

import Combine

import HilingualDomain
import HilingualNetwork

public final class DefaultSharedDiaryRepository: SharedDiaryRepository {
    
    private var service: MockSharedDiaryService
    
    public init(service: MockSharedDiaryService) {
        self.service = service
    }
    
    public func fetchSharedDiary(diaryId: Int) -> AnyPublisher<SharedDiaryEntity, Error> {
        return service.fetchSharedDiary(diaryId: diaryId)
            .tryMap { dto -> SharedDiaryEntity in
                let data = dto.data
                
                let profile = SharedDiaryEntity.Profile(
                    userId: data.profile.userId,
                    profileImg: data.profile.profileImg,
                    nickname: data.profile.nickname,
                    streak: data.profile.streak
                )
                
                let diary = SharedDiaryEntity.Diary(
                    sharedDate: data.diary.sharedDate,
                    likeCount: data.diary.likeCount,
                    isLiked: data.diary.isLiked
                )
                
                return SharedDiaryEntity(
                    isMine: data.isMine,
                    profile: profile,
                    diary: diary
                )
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    public func toggleLike(diaryId: Int, isLiked: Bool) -> AnyPublisher<Void, Error> {
        return service.toggleLike(diaryId: diaryId, isLiked: isLiked)
    }
}
