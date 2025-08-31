//
//  MockFeedSearchService.swift
//  HilingualNetwork
//
//  Created by 신혜연 on 8/29/25.
//

import Foundation
import Combine

public protocol FeedSearchService {
    func search(keyword: String) -> AnyPublisher<BaseAPIResponse<UserListDataDTO>, Error>
}

public final class MockFeedSearchService: FeedSearchService {
    public init() {}
    
    public func search(keyword: String) -> AnyPublisher<BaseAPIResponse<UserListDataDTO>, Error> {
        return Deferred { [keyword] in
            let allUsers = [
                UserDTO(userId: 1, profileImg: "https://example.com/profile1.jpg", nickname: "하링이", isFollowing: true, isFollowed: false),
                UserDTO(userId: 2, profileImg: "https://example.com/profile3.jpg", nickname: "하요링", isFollowing: false, isFollowed: true),
                UserDTO(userId: 3, profileImg: "https://example.com/profile1.jpg", nickname: "하드링", isFollowing: true, isFollowed: false),
                UserDTO(userId: 4, profileImg: "https://example.com/profile3.jpg", nickname: "하쟈링", isFollowing: false, isFollowed: true),
                UserDTO(userId: 5, profileImg: "https://example.com/profile3.jpg", nickname: "하버링", isFollowing: false, isFollowed: true),
                UserDTO(userId: 6, profileImg: "https://example.com/profile3.jpg", nickname: "하기획링", isFollowing: true, isFollowed: true)
            ]
            
            let filteredUsers = allUsers.filter { $0.nickname.contains(keyword) }
            let mockData = UserListDataDTO(userList: filteredUsers)
            let response = BaseAPIResponse(code: 20000, data: mockData, message: "사용자 검색 결과입니다.")
            
            return Just(response)
                .setFailureType(to: Error.self)
        }
        .eraseToAnyPublisher()
    }
}
