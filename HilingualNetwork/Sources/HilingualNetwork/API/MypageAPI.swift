//
//  MypageAPI.swift
//  HilingualNetwork
//
//  Created by 성현주 on 9/9/25.
//

import Foundation
import Moya

public enum MypageAPI {
    case fetchMyProfile
    case updateProfileImage(request: ProfileImageRequestDTO)
    case updateNickname(request: NicknameRequestDTO)
}

extension MypageAPI: BaseTargetType {

    public var path: String {
        switch self {
        case .fetchMyProfile:
            return "/users/mypage/info"
        case .updateProfileImage:
            return "/users/mypage/profileImg"
        case .updateNickname:
            return "/users/profile/nickname"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .fetchMyProfile:
            return .get
        case .updateProfileImage, .updateNickname:
            return .patch
        }
    }

    public var task: Task {
        switch self {
        case .fetchMyProfile:
            return .requestPlain
        case .updateProfileImage(let request):
            return .requestJSONEncodable(request)
        case .updateNickname(let request):
            return .requestJSONEncodable(request)
        }
    }
}
