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

public struct FollowUserModel: UserDisplayable {
    let userId: Int
    let profileImg: String
    let nickname: String
    let buttonState: FollowButtonState
}

public struct FollowListModel {
    var type: FollowListType
    var users: [FollowUserModel]
}

public final class FollowListViewModel: BaseViewModel {
    
    // MARK: - Published Properties
    
    private let followerListSubject = CurrentValueSubject<[FollowUserModel], Never>([])
    private let followingListSubject = CurrentValueSubject<[FollowUserModel], Never>([])
    
    public var followerListPublisher: AnyPublisher<[FollowUserModel], Never> {
        followerListSubject.eraseToAnyPublisher()
    }
    
    public var followingListPublisher: AnyPublisher<[FollowUserModel], Never> {
        followingListSubject.eraseToAnyPublisher()
    }
    
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
        let followerList: AnyPublisher<[FollowUserModel], Never>
        let followingList: AnyPublisher<[FollowUserModel], Never>
    }
    
    public lazy var input = Input()
    public lazy var output = Output(
        followerList: followerListPublisher,
        followingList: followingListPublisher
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
                let userModels = followers.map { self.mapToUserModel(from: $0, type: .follower) }
                self.followerListSubject.send(userModels)
            })
            .store(in: &cancellables)
    }
    
    func fetchFollowing() {
        followListUseCase.fetchFollowing()
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] following in
                guard let self = self else { return }
                self.originalFollowing = following
                let userModels = following.map { self.mapToUserModel(from: $0, type: .following) }
                self.followingListSubject.send(userModels)
            })
            .store(in: &cancellables)
    }
    
    // MARK: - Private Methods
    
    private func handleFollowAction(for userId: Int) {
        if let userIndex = originalFollowers.firstIndex(where: { $0.userId == userId }) {
            let updatedUser = toggleFollowState(for: originalFollowers[userIndex])
            originalFollowers[userIndex] = updatedUser
            
            var updatedList = followerListSubject.value
            if let uiIndex = updatedList.firstIndex(where: { $0.userId == userId }) {
                updatedList[uiIndex] = mapToUserModel(from: updatedUser, type: .follower)
                followerListSubject.send(updatedList)
            }
        }
        
        if let userIndex = originalFollowing.firstIndex(where: { $0.userId == userId }) {
            let updatedUser = toggleFollowState(for: originalFollowing[userIndex])
            originalFollowing[userIndex] = updatedUser
            
            var updatedList = followingListSubject.value
            if let uiIndex = updatedList.firstIndex(where: { $0.userId == userId }) {
                updatedList[uiIndex] = mapToUserModel(from: updatedUser, type: .following)
                followingListSubject.send(updatedList)
            }
        }
    }
    
    private func toggleFollowState(for user: Follower) -> Follower {
        return Follower(
            userId: user.userId, profileImg: user.profileImg, nickname: user.nickname,
            isFollowing: !user.isFollowing, isFollowed: user.isFollowed
        )
    }
    
    private func mapToUserModel(from domainFollower: Follower, type: FollowListType) -> FollowUserModel {
        let buttonState: FollowButtonState
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
