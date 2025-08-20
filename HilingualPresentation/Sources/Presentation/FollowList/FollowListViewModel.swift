//
//  FollowListViewModel.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 8/15/25.
//

import Foundation
import Combine

import HilingualDomain

public enum FollowListType {
    case follower
    case following
}

public struct FollowUserModel {
    let userId: Int
    let profileImg: String
    let nickname: String
    let buttonState: FollowButton.FollowButtonState
}

public struct FollowListModel {
    var type: FollowListType
    var users: [FollowUserModel]
}

public final class FollowListViewModel: BaseViewModel {
    
    // MARK: - Published Properties
    
    @Published public private(set) var followerList: [FollowUserModel] = []
    @Published public private(set) var followingList: [FollowUserModel] = []
    
    // MARK: - Private Properties
    
    private var originalFollowers: [Follower] = []
    private var originalFollowing: [Follower] = []
    
    private let followListUseCase: FollowListUseCase
    
    // MARK: - Init
    
    public init(followListUseCase: FollowListUseCase) {
        self.followListUseCase = followListUseCase
    }
    
    // MARK: - Input / Output
    
    public struct Input {
        let fetchFollowers: PassthroughSubject<Void, Never> = .init()
        let fetchFollowing: PassthroughSubject<Void, Never> = .init()
        let followButtonTapped: PassthroughSubject<Int, Never> = .init()
    }
    
    public struct Output {
        let followerList: Published<[FollowUserModel]>.Publisher
        let followingList: Published<[FollowUserModel]>.Publisher
    }
    
    public lazy var input = Input()
    public lazy var output = Output(
        followerList: $followerList,
        followingList: $followingList
    )
    
    // MARK: - Bind Inputs
    
    public func bind() {
        input.fetchFollowers
            .sink { [weak self] _ in self?.fetchFollowers() }
            .store(in: &cancellables)
        
        input.fetchFollowing
            .sink { [weak self] _ in self?.fetchFollowing() }
            .store(in: &cancellables)
        
        input.followButtonTapped
            .sink { [weak self] userId in self?.handleFollowAction(for: userId) }
            .store(in: &cancellables)
    }
    
    // MARK: - Fetch Methods
    
    func fetchFollowers() {
        followListUseCase.fetchFollowers()
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] followers in
                guard let self = self else { return }
                self.originalFollowers = followers
                self.followerList = followers.map { self.mapToUserModel(from: $0, type: .follower) }
            })
            .store(in: &cancellables)
    }
    
    func fetchFollowing() {
        followListUseCase.fetchFollowing()
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] following in
                guard let self = self else { return }
                self.originalFollowing = following
                self.followingList = following.map { self.mapToUserModel(from: $0, type: .following) }
            })
            .store(in: &cancellables)
    }
    
    // MARK: - Private Methods
    
    private func handleFollowAction(for userId: Int) {
        if let userIndex = originalFollowers.firstIndex(where: { $0.userId == userId }) {
            let updatedUser = toggleFollowState(for: originalFollowers[userIndex])
            originalFollowers[userIndex] = updatedUser
            
            var updatedList = self.followerList
            if let uiIndex = updatedList.firstIndex(where: { $0.userId == userId }) {
                updatedList[uiIndex] = mapToUserModel(from: updatedUser, type: .follower)
                self.followerList = updatedList
            }
        }
        
        if let userIndex = originalFollowing.firstIndex(where: { $0.userId == userId }) {
            let updatedUser = toggleFollowState(for: originalFollowing[userIndex])
            originalFollowing[userIndex] = updatedUser
            
            var updatedList = self.followingList
            if let uiIndex = updatedList.firstIndex(where: { $0.userId == userId }) {
                updatedList[uiIndex] = mapToUserModel(from: updatedUser, type: .following)
                self.followingList = updatedList
            }
        }
    }
    
    private func toggleFollowState(for user: Follower) -> Follower {
        return Follower(
            userId: user.userId, profileImg: user.profileImg, nickname: user.nickname,
            isFollowing: !user.isFollowing, isFollowed: user.isFollowed
        )
    }
    
    // Domain 모델을 UI 모델로 매핑
    private func mapToUserModel(from domainFollower: Follower, type: FollowListType) -> FollowUserModel {
        let buttonState: FollowButton.FollowButtonState
        switch type {
        case .follower:
            buttonState = domainFollower.isFollowing ? .following : .mutualFollow
        case .following:
            buttonState = domainFollower.isFollowing ? .following : .follow
        }
        
        return FollowUserModel(
            userId: domainFollower.userId,
            profileImg: domainFollower.profileImg,
            nickname: domainFollower.nickname,
            buttonState: buttonState
        )
    }
}
