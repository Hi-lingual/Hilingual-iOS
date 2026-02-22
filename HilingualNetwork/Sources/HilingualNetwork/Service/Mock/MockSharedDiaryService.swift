//
//  MockSharedDiaryService.swift
//  HilingualNetwork
//
//  Created by 진소은 on 8/26/25.
//

import Foundation
import Combine

//public protocol SharedDiaryService {
//    func fetchSharedDiary(diaryId: Int) -> AnyPublisher<SharedDiaryResponseDTO, Error>
//    func toggleLike(diaryId: Int, isLiked: Bool) -> AnyPublisher<Void, Error>
//}

public final class MockSharedDiaryService: SharedDiaryService {
    public init() {}
    
    private var currentIsLiked = false
    private var currentLikeCount = 3 
    
    public func fetchSharedDiary(diaryId: Int) -> AnyPublisher<SharedDiaryResponseDTO, Error> {
        let response: SharedDiaryResponseDTO
        if diaryId == 1 {
            response = SharedDiaryResponseDTO(
                code: 200,
                data: .init(
                    isMine: true,
                    profile: .init(
                        userId: 1,
                        profileImg: "https://ilovecharacter.com/news/data/20250501/p1065572674315832_435_thum.png",
                        nickname: "가나디",
                        streak: 30
                    ),
                    diary: .init(
                        sharedDate: 10,
                        likeCount: currentLikeCount,
                        isLiked: currentIsLiked
                    )
                ),
                message: "성공"
            )
        } else {
            response = SharedDiaryResponseDTO(
                code: 200,
                data: .init(
                    isMine: false,
                    profile: .init(
                        userId: 2,
                        profileImg: "https://i.namu.wiki/i/AGwhfLbqwPfe613VURNaKVefq1E_bf1MeC5HiML8DxigsOZWQy4Fs9hPmcf24nR8QJAlwj5P8NrNEJX-Vst7tw.webp",
                        nickname: "모몽가",
                        streak: 5
                    ),
                    diary: .init(
                        sharedDate: 120,
                        likeCount: currentLikeCount,
                        isLiked: currentIsLiked
                    )
                ),
                message: "성공"
            )
        }
        
        return Just(response)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    public func toggleLike(diaryId: Int, isLiked: Bool) -> AnyPublisher<Void, Error> {
        if isLiked && !currentIsLiked {
            currentLikeCount += 1
        } else if !isLiked && currentIsLiked {
            currentLikeCount = max(0, currentLikeCount - 1)
        }
        currentIsLiked = isLiked
        
        print("Mock toggleLike called → diaryId: \(diaryId), isLiked: \(isLiked), likeCount: \(currentLikeCount)")
        
        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
