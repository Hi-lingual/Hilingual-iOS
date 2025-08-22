//
//  MockFeedProfileService.swift
//  HilingualNetwork
//
//  Created by 조영서 on 8/22/25.
//

import Foundation
import Combine

public final class MockFeedProfileService: FeedProfileService {
    
    public init() {}
    
    // 공유 피드
    public func fetchSharedFeed(targetUserId: Int64) -> AnyPublisher<SharedFeedResponseDTO, Error> {
        let dto: SharedFeedResponseDTO
        
        switch targetUserId {
        case 0: // 내 프로필
            dto = SharedFeedResponseDTO(
                code: 20000,
                data: SharedFeedDataDTO(
                    profile: SharedProfileDTO(profileImg: "https://image.aladin.co.kr/Tobe/Thumbs/7AS4S2/Y3S223/638799314905503647_0.png?RS=600&FI=100", nickname: "내 프로필임"),
                    diaryList: []
//                    diaryList: sampleSharedItemsForMe()
                ),
                message: "공유된 일기를 조회했습니다."
            )
        case 1: // 타인 프로필
            dto = SharedFeedResponseDTO(
                code: 20000,
                data: SharedFeedDataDTO(
                    profile: SharedProfileDTO(profileImg: "https://i.namu.wiki/i/ox5e5MMg8cRJiIm65Tm7DhzLAw5Kjz8n-96WESaHdpWm59PhwQJo0gi8pdMWW1cKONtAlitKsLWNrvnPNlHxlQ.webp", nickname: "타인프로필임"),
                    diaryList: sampleSharedItemsForOther()
                ),
                message: "공유된 일기를 조회했습니다."
            )
        default: // 데이터 없음
            dto = SharedFeedResponseDTO(
                code: 20000,
                data: SharedFeedDataDTO(profile: SharedProfileDTO(profileImg: "", nickname: ""), diaryList: []),
                message: "공유된 일기가 없습니다."
            )
        }
        
        return just(dto)
    }
    
    // 공감 피드
    public func fetchLikedFeed(targetUserId: Int64) -> AnyPublisher<LikedFeedResponseDTO, Error> {
        let dto: LikedFeedResponseDTO
        
        switch targetUserId {
        case 0: // 내 프로필
            dto = LikedFeedResponseDTO(
                code: 20000,
                data: LikedFeedDataDTO(
                    diaryList: sampleLikedItemsForMe()),
                message: "공유된 일기를 조회했습니다."
            )
        default: // 데이터 없음
            dto = LikedFeedResponseDTO(
                code: 20000,
                data: LikedFeedDataDTO(diaryList: []),
                message: "공감한 일기가 없습니다."
            )
        }
        
        return just(dto)
    }
    
    // MARK: - Helpers
    private func just<T>(_ value: T) -> AnyPublisher<T, Error> {
        Just(value)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Sample Data
    
    private func sampleSharedItemsForMe() -> [ProfileDiaryDTO] {
        [
            .init(diaryId: 1, sharedDate: 120, likeCount: 10, isLiked: true, diaryImg: nil, originalText: "Had a presentation today and it was a disaster. My voice was shaking, my slides didn’t work properly, and I forgot what I wanted to say. So 답답하다. I know I should’ve practiced more, but still. Hate days like this"),
            .init(diaryId: 2, sharedDate: 300, likeCount: 2, isLiked: false, diaryImg: "https://t1.daumcdn.net/gift/pagebuilder/image/page/30364/20250604_VCAWA.jpeg", originalText: "Had a presentation today and it was a disaster. My voice was shaking, my slides didn’t work properly, and I forgot what I wanted to say. So 답답하다. I know I should’ve practiced more, but still. Hate days like this.")
        ]
    }
    
    private func sampleSharedItemsForOther() -> [ProfileDiaryDTO] {
        [
            .init(diaryId: 11, sharedDate: 500, likeCount: 5, isLiked: true, diaryImg: "https://t1.daumcdn.net/gift/pagebuilder/image/page/30364/20250604_VCAWA.jpeg", originalText: "Had a presentation today and it was a disaster. My voice was shaking, my slides didn’t work properly, and I forgot what I wanted to say. So 답답하다. I know I should’ve practiced more, but still. Hate days like this.")
        ]
    }
    
    private func sampleLikedItemsForMe() -> [FeedProfileItemDTO] {
        [
            .init(
                profile: .init(userId: 21, isMine: true, profileImg: "https://i.pinimg.com/236x/a5/73/59/a5735920142505068fd1e5ebd0ce86f1.jpg", nickname: "영돌이", streak: 3),
                diary: .init(diaryId: 1, sharedDate: 100, likeCount: 6, isLiked: true, diaryImg: nil, originalText: "Had a presentation today and it was a disaster. My voice was shaking, my slides didn’t work properly, and I forgot what I wanted to say. So 답답하다. I know I should’ve practiced more, but still. Hate days like this.")
            ),
            .init(
                profile: .init(userId: 22, isMine: false, profileImg: "https://i.pinimg.com/originals/af/02/3b/af023b7013e446db3baf09ee81a1eecd.jpg", nickname: "영구리", streak: 5),
                diary: .init(diaryId: 2, sharedDate: 200, likeCount: 8, isLiked: false, diaryImg: "https://t1.daumcdn.net/gift/pagebuilder/image/page/30364/20250604_VCAWA.jpeg", originalText: "Had a presentation today and it was a disaster. My voice was shaking, my slides didn’t work properly, and I forgot what I wanted to say. So 답답하다. I know I should’ve practiced more, but still. Hate days like this.")
            ),
            .init(
                profile: .init(userId: 22, isMine: false, profileImg: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxHhMoCa_TuFbtBuWFPFJ1jdP9jHWD3AwC7w&s", nickname: "영서", streak: 5),
                diary: .init(diaryId: 2, sharedDate: 200, likeCount: 8, isLiked: false, diaryImg: "https://t1.daumcdn.net/gift/pagebuilder/image/page/30364/20250604_VCAWA.jpeg", originalText: "Had a presentation today and it was a disaster. My voice was shaking, my slides didn’t work properly, and I forgot what I wanted to say. So 답답하다. I know I should’ve practiced more, but still. Hate days like this.")
            ),
            .init(
                profile: .init(userId: 22, isMine: false, profileImg: "https://i.pinimg.com/originals/af/02/3b/af023b7013e446db3baf09ee81a1eecd.jpg", nickname: "영도리", streak: 5),
                diary: .init(diaryId: 2, sharedDate: 200, likeCount: 8, isLiked: false, diaryImg: "https://t1.daumcdn.net/gift/pagebuilder/image/page/30364/20250604_VCAWA.jpeg", originalText: "Had a presentation today and it was a disaster. My voice was shaking, my slides didn’t work properly, and I forgot what I wanted to say. So 답답하다. I know I should’ve practiced more, but still. Hate days like this.")
            )
        ]
    }
}
