//
//  MockSharedDiaryService.swift
//  HilingualNetwork
//
//  Created by 진소은 on 8/26/25.
//

import Foundation
import Combine

public protocol SharedDiaryService {
    func fetchSharedDiary(diaryId: Int) -> AnyPublisher<SharedDiaryResponseDTO, Error>
    func toggleLike(diaryId: Int, isLiked: Bool) -> AnyPublisher<Void, Error>
}

public final class MockSharedDiaryService: SharedDiaryService {
    public init() {}
    
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
                        likeCount: 3,
                        isLiked: false
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
                        likeCount: 15,
                        isLiked: true
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
        // 파라미터 그대로만 반영 (상태 저장 없음)
        print("Mock toggleLike called → diaryId: \(diaryId), isLiked: \(isLiked)")
        
        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
