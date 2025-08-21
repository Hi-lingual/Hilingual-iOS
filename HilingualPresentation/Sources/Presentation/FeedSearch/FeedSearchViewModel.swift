//
//  FeedSearchViewModel.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 8/20/25.
//

import Foundation
import Combine

import HilingualDomain

public struct FeedSearchUser {
    public let userId: Int
    public let profileImg: String
    public let nickname: String
    public var isFollowing: Bool
    public var isFollowed: Bool
}

public enum SearchState {
    case enter // 처음 진입 시
    case searchResult([FeedSearchUser]) // 검색 결과가 있으면
    case empty // 검색 결과가 없으면
}

public final class FeedSearchViewModel: BaseViewModel {
    
    // MARK: - Input / Output
    
    public struct Input {
        let searchTrigger: PassthroughSubject<String, Never>
        let followButtonTapped: PassthroughSubject<Int, Never> = .init()
    }
    
    public struct Output {
        let searchState: AnyPublisher<SearchState, Never>
    }
    
    // MARK: - Properties
    
    public var input = Input(searchTrigger: .init())
    
    // MARK: - Init
    
    public override init() {
        super.init()
        setBinding()
    }
    
    // MARK: - Bindings
    
    private func setBinding() {
        input.followButtonTapped
            .sink { userId in
                print("Follow 버튼 탭 userId:", userId)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Transform
    
    public func transform() -> Output {
        let searchStatePublisher = input.searchTrigger
            .map { query -> SearchState in
                guard !query.isEmpty else { return .enter }

                let mockData: [FeedSearchUser] = [
                    FeedSearchUser(userId: 1, profileImg: "https://example.com/image1.jpg", nickname: "하링이", isFollowing: false, isFollowed: true),
                    FeedSearchUser(userId: 2, profileImg: "https://example.com/image2.jpg", nickname: "하이링구얼", isFollowing: true, isFollowed: true),
                    FeedSearchUser(userId: 3, profileImg: "https://example.com/image3.jpg", nickname: "하이링궐", isFollowing: false, isFollowed: false),
                    FeedSearchUser(userId: 4, profileImg: "https://example.com/image4.jpg", nickname: "하품그만해", isFollowing: true, isFollowed: false)
                ]

                let filtered = mockData.filter { $0.nickname.contains(query) }
                return filtered.isEmpty ? .empty : .searchResult(filtered)
            }
            .eraseToAnyPublisher()

        return Output(searchState: searchStatePublisher)
    }
}
