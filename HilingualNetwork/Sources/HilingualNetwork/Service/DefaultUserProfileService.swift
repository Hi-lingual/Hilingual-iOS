//
//  UserProfileService.swift
//  HilingualNetwork
//
//  Created by 성현주 on 9/9/25.
//

import Combine
import Moya

public protocol UserProfileService {
    func fetchMyProfile() -> AnyPublisher<UserProfileResponseDTO, Error>
}

public final class DefaultUserProfileService: BaseService<MypageAPI>, UserProfileService {
    public func fetchMyProfile() -> AnyPublisher<UserProfileResponseDTO, Error> {
        request(.fetchMyProfile, as: BaseAPIResponse<UserProfileResponseDTO>.self)
            .tryMap { response in
                return response.data
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

}
