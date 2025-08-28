//
//  ToggleLikeUseCase.swift
//  HilingualDomain
//
//  Created by 진소은 on 8/26/25.
//

import Combine

public protocol ToggleLikeUseCase {
    func toggleLike(diaryId: Int, isLiked: Bool) -> AnyPublisher<Void, Error>
}

public final class DefaultToggleLikeUseCase: ToggleLikeUseCase {
    private let repository: SharedDiaryRepository
    
    public init(repository: SharedDiaryRepository) {
        self.repository = repository
    }
    
    public func toggleLike(diaryId: Int, isLiked: Bool) -> AnyPublisher<Void, Error> {
        return repository.toggleLike(diaryId: diaryId, isLiked: isLiked)
    }
}
