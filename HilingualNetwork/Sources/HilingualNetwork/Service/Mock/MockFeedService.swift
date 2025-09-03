//
//  MockFeedService.swift
//  HilingualNetwork
//
//  Created by 조영서 on 8/21/25.
//

import Foundation
import Combine


public final class MockFeedService: FeedService {

    public init() {}

    public func fetchRecommendedFeed() -> AnyPublisher<RecommendedFeedResponseDTO, Error> {
        let dto = RecommendedFeedResponseDTO(
            code: 20000,
            data: FeedListDTO(diaryList: sampleItemsForRecommended()),
            message: "추천 일기를 조회했습니다."
        )
        return just(dto)
    }

    // 데이터 있을 경우
//    public func fetchFollowingFeed() -> AnyPublisher<FollowingFeedResponseDTO, Error> {
//        let dto = FollowingFeedResponseDTO(
//            code: 20000,
//            data: FeedListDTO(
//                diaryList: sampleItemsForFollowing(),
//                haveFollowing: true
//            ),
//            message: "팔로잉한 유저들의 일기를 조회했습니다."
//        )
//        return Just(dto)
//            .setFailureType(to: Error.self)
//            .eraseToAnyPublisher()
//    }
    
    // 데이터 없을 경우
//    public func fetchFollowingFeed() -> AnyPublisher<FollowingFeedResponseDTO, Error> {
//        let dto = FollowingFeedResponseDTO(
//            code: 20000,
//            data: FeedListDTO(
//                diaryList: [],
//                haveFollowing: true
//            ),
//            message: "팔로잉한 유저들의 일기를 조회했습니다."
//        )
//        return Just(dto)
//            .setFailureType(to: Error.self)
//            .eraseToAnyPublisher()
//    }
    
    // 팔로잉 없을 경우
    public func fetchFollowingFeed() -> AnyPublisher<FollowingFeedResponseDTO, Error> {
        let dto = FollowingFeedResponseDTO(
            code: 20000,
            data: FeedListDTO(
                diaryList: [],
                haveFollowing: false
            ),
            message: "팔로잉한 유저가 없습니다."
        )
        return Just(dto)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    // MARK: - Helpers
    private func just<T>(_ value: T) -> AnyPublisher<T, Error> {
        Just(value)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    // 목데이터
    private func sampleItemsForRecommended() -> [FeedItemDTO] {
        [
            .init(
                profile: .init(userId: 0,  isMine: true, profileImg: "https://image.aladin.co.kr/Tobe/Thumbs/7AS4S2/Y3S223/638799314905503647_0.png?RS=600&FI=100", nickname: "밍",     streak: 3),
                diary:   .init(diaryId: 1,  sharedDate: 2500, likeCount: 6, isLiked: true,  diaryImg: "https://t1.daumcdn.net/gift/pagebuilder/image/page/30364/20250604_VCAWA.jpeg", originalText: "Had a presentation today and it was a disaster. My voice was shaking, my slides didn’t work properly, and I forgot what I wanted to say. So 답답하다. I know I should’ve practiced more, but still. Hate days like this.")
            ),
            .init(
                profile: .init(userId: 1,  isMine: false, profileImg: "https://i.namu.wiki/i/ox5e5MMg8cRJiIm65Tm7DhzLAw5Kjz8n-96WESaHdpWm59PhwQJo0gi8pdMWW1cKONtAlitKsLWNrvnPNlHxlQ.webp", nickname: "짝나귀여워", streak: 3),
                diary:   .init(diaryId: 23, sharedDate: 2500, likeCount: 6, isLiked: false, diaryImg: nil,                         originalText: "Had a presentation today and it was a disaster. My voice was...")
            ),
            .init(
                profile: .init(userId: 1, isMine: false, profileImg: "https://image.aladin.co.kr/Tobe/Thumbs/7AS4S2/Y3S223/638799314905503647_0.png?RS=600&FI=100", nickname: "큰나귀여워", streak: 3),
                diary:   .init(diaryId: 41, sharedDate: 2500, likeCount: 6, isLiked: true,  diaryImg: "https://t1.daumcdn.net/gift/pagebuilder/image/page/30364/20250604_VCAWA.jpeg", originalText: "Had a presentation today and it was a disaster. My voice was shaking, my slides didn’t work properly, and I forgot what I wanted to say. So 답답하다. I know I should’ve practiced more, but still. Hate days like this.")
            )
        ]
    }

    private func sampleItemsForFollowing() -> [FeedItemDTO] {
        [
            .init(
                profile: .init(userId: 21,  isMine: false, profileImg: "https://i.namu.wiki/i/ox5e5MMg8cRJiIm65Tm7DhzLAw5Kjz8n-96WESaHdpWm59PhwQJo0gi8pdMWW1cKONtAlitKsLWNrvnPNlHxlQ.webp", nickname: "밍",     streak: 3),
                diary:   .init(diaryId: 1,  sharedDate: 2500, likeCount: 6, isLiked: true,  diaryImg: "https://t1.daumcdn.net/gift/pagebuilder/image/page/30364/20250604_VCAWA.jpeg", originalText: "Had a presentation today and it was a disaster. My voice was shaking, my slides didn’t work properly, and I forgot what I wanted to say. So 답답하다. I know I should’ve practiced more, but still. Hate days like this.")
            ),
            .init(
                profile: .init(userId: 433, isMine: false, profileImg: "https://image.aladin.co.kr/Tobe/Thumbs/7AS4S2/Y3S223/638799314905503647_0.png?RS=600&FI=100", nickname: "짝나귀여워", streak: 3),
                diary:   .init(diaryId: 23, sharedDate: 2500, likeCount: 6, isLiked: false, diaryImg: nil,                         originalText: "Today was the most stressful day in 2025 for me. It was the team building day at SOPT. I dreaded this day because I didn't know what to expect. The process was complicated and the group(?) and then peo")
            ),
            .init(
                profile: .init(userId: 12,  isMine: false, profileImg: "https://ocdn.com..", nickname: "큰나귀여워", streak: 3),
                diary:   .init(diaryId: 41, sharedDate: 2500, likeCount: 6, isLiked: true,  diaryImg: "https://t1.daumcdn.net/gift/pagebuilder/image/page/30364/20250604_VCAWA.jpeg", originalText: "Had a presentation today and it was a disaster. My voice was shaking, my slides didn’t work properly, and I forgot what I wanted to say. So 답답하다. I know I should’ve practiced more, but still. Hate days like this.")
            )
        ]
    }
}
