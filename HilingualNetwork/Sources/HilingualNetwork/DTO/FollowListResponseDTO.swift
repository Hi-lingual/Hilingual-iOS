//
//  FollowListResponseDTO.swift
//  HilingualNetwork
//
//  Created by 신혜연 on 8/20/25.
//

public struct FollowListResponseDTO: Codable {
    public let code: Int
    public let data: FollowListDataDTO
    public let message: String

    public init(code: Int, data: FollowListDataDTO, message: String) {
        self.code = code
        self.data = data
        self.message = message
    }
}

public struct FollowListDataDTO: Codable {
    public let followerList: [FollowerDTO]?
    public let followingList: [FollowerDTO]?

    public init(followerList: [FollowerDTO]? = nil, followingList: [FollowerDTO]? = nil) {
        self.followerList = followerList
        self.followingList = followingList
    }
}

public struct FollowerDTO: Codable {
    public let userId: Int
    public let profileImg: String
    public let nickname: String
    public let isFollowing: Bool
    public let isFollowed: Bool

    public init(
        userId: Int,
        profileImg: String,
        nickname: String,
        isFollowing: Bool,
        isFollowed: Bool
    ) {
        self.userId = userId
        self.profileImg = profileImg
        self.nickname = nickname
        self.isFollowing = isFollowing
        self.isFollowed = isFollowed
    }
}

// MARK: - Mock 팔로워/팔로잉 데이터
extension FollowListResponseDTO {
    
    public static let mockFollowers: FollowListResponseDTO = {
        let followers = [
            FollowerDTO(userId: 1, profileImg: "image/url/.jpg", nickname: "닉네임이지롱1", isFollowing: true, isFollowed: true),
            FollowerDTO(userId: 2, profileImg: "image/url/.jpg", nickname: "닉네임이지롱2", isFollowing: false, isFollowed: true),
            FollowerDTO(userId: 3, profileImg: "image/url/.jpg", nickname: "닉네임이지롱3", isFollowing: true, isFollowed: true)
        ]
        let data = FollowListDataDTO(followerList: followers, followingList: nil)
        let dto = FollowListResponseDTO(code: 20000, data: data, message: "팔로워 리스트를 조회했습니다.")
        
        print("Mock Followers 생성됨:", dto)
        return dto
    }()
    
    public static let mockFollowing: FollowListResponseDTO = {
        let following = [
            FollowerDTO(userId: 4, profileImg: "image/url/.jpg", nickname: "팔로잉닉네임1", isFollowing: true, isFollowed: true),
            FollowerDTO(userId: 5, profileImg: "image/url/.jpg", nickname: "팔로잉닉네임2", isFollowing: true, isFollowed: false),
            FollowerDTO(userId: 6, profileImg: "image/url/.jpg", nickname: "팔로잉닉네임3", isFollowing: true, isFollowed: true)
        ]
        let data = FollowListDataDTO(followerList: nil, followingList: following)
        let dto = FollowListResponseDTO(code: 20000, data: data, message: "팔로잉 리스트를 조회했습니다.")
        
        print("Mock Following 생성됨:", dto)
        return dto
    }()
}
