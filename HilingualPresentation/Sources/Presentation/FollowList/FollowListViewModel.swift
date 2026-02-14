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
    public var isFollowing: Bool
    public var isFollowed: Bool
    var buttonState: FollowButtonState
}

public struct FollowListModel {
    var type: FollowListType
    var users: [FollowUserModel]
}

public final class FollowListViewModel: BaseViewModel {
    
    // MARK: - Published Properties
    
    private let followListSubject = CurrentValueSubject<FollowListModel, Never>(.init(type: .follower, users: []))
    
    public var followListPublisher: AnyPublisher<FollowListModel, Never> {
        return followListSubject.eraseToAnyPublisher()
    }
    
    private let userUpdateSubject = PassthroughSubject<FollowUserModel, Never>()
    
    public var userUpdatePublisher: AnyPublisher<FollowUserModel, Never> {
        return userUpdateSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Private Properties
    
    private var originalFollowers: [Follower] = []
    private var originalFollowing: [Follower] = []
    
    private let followListUseCase: FollowListUseCase
    private let targetUserId: Int
    
    // MARK: - Init
    
    public init(followListUseCase: FollowListUseCase, targetUserId: Int) {
        self.followListUseCase = followListUseCase
        self.targetUserId = targetUserId
        super.init()
    }
    
    // MARK: - Input / Output
    
    public struct Input {
        let fetchFollowers: PassthroughSubject<Void, Never> = .init()
        let fetchFollowing: PassthroughSubject<Void, Never> = .init()
        let followButtonTapped: PassthroughSubject<Int, Never> = .init()
    }
    
    public struct Output {
        let followList: AnyPublisher<FollowListModel, Never>
    }
    
    public lazy var input = Input()
    public lazy var output = Output(followList: followListPublisher)
    
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
        followListUseCase.fetchFollowers(targetUserId: targetUserId)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] followers in
                guard let self = self else { return }
                self.originalFollowers = followers
                let userModels = followers.map { self.mapToUserModel(from: $0, type: .follower) }
                self.followListSubject.send(.init(type: .follower, users: userModels))
            })
            .store(in: &cancellables)
    }
    
    func fetchFollowing() {
        followListUseCase.fetchFollowings(targetUserId: targetUserId)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] following in
                guard let self = self else { return }
                self.originalFollowing = following
                let userModels = following.map { self.mapToUserModel(from: $0, type: .following) }
                self.followListSubject.send(.init(type: .following, users: userModels))
            })
            .store(in: &cancellables)
    }
    
    // MARK: - Private Methods
    
    private func handleFollowAction(for userId: Int) {
        var list = followListSubject.value
        guard let index = list.users.firstIndex(where: { $0.userId == userId }) else { return }
        var user = list.users[index]
        
        let shouldFollow = !user.isFollowing
        
        let actionPublisher: AnyPublisher<Bool, Error> = shouldFollow
        ? followListUseCase.follow(userId: user.userId).map { true }.eraseToAnyPublisher()
        : followListUseCase.unfollow(userId: user.userId)
        
        actionPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard self != nil else { return }
            }, receiveValue: { [weak self] success in
                guard let self = self else { return }
                user.isFollowing = shouldFollow
                user.buttonState = self.buttonState(for: user, type: list.type)
                list.users[index] = user
                
                self.userUpdateSubject.send(user)
                self.followListSubject.send(list)
            })
            .store(in: &cancellables)
    }
    
    private func buttonState(for user: FollowUserModel, type: FollowListType) -> FollowButtonState {
        switch type {
        case .follower:
            if user.isFollowing && user.isFollowed { return .following }
            else if user.isFollowed { return .mutualFollow }
            else if user.isFollowing { return .following }
            else { return .follow }
        case .following:
            if user.isFollowing && user.isFollowed { return .following }
            else if user.isFollowed { return .mutualFollow }
            else if user.isFollowing { return .following }
            else { return .follow }
        }
    }
    
    private func mapToUserModel(from domainFollower: Follower, type: FollowListType) -> FollowUserModel {
        let buttonState: FollowButtonState
        if domainFollower.isFollowing && domainFollower.isFollowed {
            buttonState = .following
        } else if domainFollower.isFollowing {
            buttonState = .following
        } else if domainFollower.isFollowed {
            buttonState = .mutualFollow
        } else {
            buttonState = .follow
        }
        return FollowUserModel(
            userId: domainFollower.userId,
            profileImg: domainFollower.profileImg,
            nickname: domainFollower.nickname,
            isFollowing: domainFollower.isFollowing,
            isFollowed: domainFollower.isFollowed,
            buttonState: buttonState
        )
    }
}
