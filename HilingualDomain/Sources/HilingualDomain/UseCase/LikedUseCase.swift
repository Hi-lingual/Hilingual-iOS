//
//  LikedUseCase.swift
//  HilingualDomain
//
//  Created by 진소은 on 8/26/25.
//

import Foundation
import Combine

public protocol LikedUseCase {
    func toggleLike(diaryId: Int, isLiked: Bool) -> AnyPublisher<Void, Error>
}

//public final class DefaultLikedUseCase: LikedUseCase {
//    private let repository:
//}
