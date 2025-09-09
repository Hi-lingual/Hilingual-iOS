//
//  FeedSearchViewModel.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 8/20/25.
//

import Foundation
import Combine

import HilingualDomain

public struct FeedSearchUserModel: UserDisplayable {
    public let userId: Int
    public let profileImg: String
    public let nickname: String
    public var isFollowing: Bool
    public var isFollowed: Bool
    public var buttonState: FollowButtonState {
        if isFollowing && isFollowed {
            return .following
        } else if isFollowing && !isFollowed {
            return .following
        } else if !isFollowing && isFollowed {
            return .mutualFollow
        } else {
            return .follow
        }
    }
}

public enum SearchState {
    case enter // 처음 진입 시
    case searchResult([FeedSearchUserModel]) // 검색 결과가 있으면
    case empty // 검색 결과가 없으면
}

public final class FeedSearchViewModel: BaseViewModel {
    
    // MARK: - Input / Output
    
    public struct Input {
        let searchTrigger: PassthroughSubject<String, Never>
        let followButtonTapped: PassthroughSubject<(userId: Int, isFollowing: Bool), Never> = .init()
    }
    
    public struct Output {
        let searchState: AnyPublisher<SearchState, Never>
        let followAction: AnyPublisher<(userId: Int, isFollowing: Bool), Never>
    }
    
    // MARK: - Properties
    
    public var input = Input(searchTrigger: .init())
    private let useCase: FeedSearchUseCase
    
    // MARK: - Init
    
    public init(useCase: FeedSearchUseCase) {
        self.useCase = useCase
        super.init()
        
        setBinding()
    }
    
    // MARK: - Bindings
    
    private func setBinding() {
        input.followButtonTapped
            .sink { userId in
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Transform
    
    public func transform() -> Output {
        // 검색 스트림
        let searchStatePublisher = input.searchTrigger
            .flatMap { [weak self] query -> AnyPublisher<SearchState, Never> in
                guard let self = self, !query.isEmpty else {
                    return Just(.enter).eraseToAnyPublisher()
                }
                
                return self.useCase.search(keyword: query)
                    .map { entities in
                        entities.map { entity in
                            FeedSearchUserModel(
                                userId: entity.userId,
                                profileImg: entity.profileImg,
                                nickname: entity.nickname,
                                isFollowing: entity.isFollowing,
                                isFollowed: entity.isFollowed
                            )
                        }
                    }
                    .map { users in
                        users.isEmpty ? .empty : .searchResult(users)
                    }
                    .catch { _ in Just(.empty) }
                    .receive(on: DispatchQueue.main)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        // 팔로우 액션 스트림
        let followActionPublisher = input.followButtonTapped
            .flatMap { [weak self] (userId, currentState) -> AnyPublisher<(userId: Int, isFollowing: Bool), Never> in
                guard let self = self else { return Empty().eraseToAnyPublisher() }
                
                let newState = !currentState
                let publisher: AnyPublisher<Void, Error> = newState
                ? self.useCase.follow(userId: userId)
                : self.useCase.unfollow(userId: userId).map { _ in () }.eraseToAnyPublisher()
                
                return publisher
                    .map { (userId: userId, isFollowing: newState) }
                    .catch { _ in Just((userId: userId, isFollowing: currentState)) }
                    .receive(on: DispatchQueue.main)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        return Output(
            searchState: searchStatePublisher,
            followAction: followActionPublisher
        )
    }
}
