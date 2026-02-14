//
//  MockFeedProfileInfoService.swift
//  HilingualNetwork
//
//  Created by 조영서 on 8/26/25.
//

import Foundation
import Combine

public final class MockFeedProfileInfoService: FeedProfileInfoService {
    
    private let isMine: Bool
    
    public init(isMine: Bool) {
        self.isMine = isMine
    }
    
    public func fetchProfileInfo(targetUserId: Int64) -> AnyPublisher<FeedProfileInfoResponseDTO, Error> {
        let dto: FeedProfileInfoResponseDTO
        
        if isMine {
            dto = FeedProfileInfoResponseDTO(
                code: 20000,
                data: FeedProfileInfoDTO(
                    isMine: true,
                    profileImg: "https://image.aladin.co.kr/Tobe/Thumbs/7AS4S2/Y3S223/638799314905503647_0.png?RS=600&FI=100",
                    nickname: "영돌",
                    follower: 123,
                    following: 37,
                    streak: 6,
                    isFollowing: nil,
                    isFollowed: nil,
                    isBlocked: nil
                ),
                message: "성공했습니다"
            )
        } else {
            dto = FeedProfileInfoResponseDTO(
                code: 20000,
                data: FeedProfileInfoDTO(
                    isMine: false,
                    profileImg: " ",
                    nickname: "타인프로필링",
                    follower: 1244,
                    following: 3712,
                    streak: 999,
                    isFollowing: true,
                    isFollowed: false,
                    isBlocked: false
                ),
                message: "성공했습니다"
            )
        }
        
        return Just(dto)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
