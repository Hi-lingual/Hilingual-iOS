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
    let buttonState: FollowButtonState
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
        self.bind()
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
        var currentList = followListSubject.value
        
        if let userIndex = currentList.users.firstIndex(where: { $0.userId == userId }) {
            // API 호출 로직
            // followListUseCase.performFollowAction(userId: userId)
            //     .sink(receiveCompletion: { _ in }, receiveValue: { _ in
            //         // 성공 시 로컬 상태 업데이트
            //     })
            //     .store(in: &cancellables)
            
            currentList.users[userIndex].isFollowing.toggle()
            
            // 뷰모델의 상태를 업데이트합니다.
            followListSubject.send(currentList)
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
            isFollowing: domainFollower.isFollowing,
            isFollowed: domainFollower.isFollowed,
            buttonState: buttonState
        )
    }
}
