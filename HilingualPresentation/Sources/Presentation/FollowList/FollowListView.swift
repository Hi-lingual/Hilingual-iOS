//
//  FollowListView.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 8/15/25.
//

import UIKit

final class FollowListView: BaseUIView {
    
    // MARK: - Mock
    
    struct Follower {
        var id: Int
        var nickname: String
        var isFollowing: Bool   // 내가 상대방을 팔로잉 중인지
        var isFollowed: Bool    // 상대방이 나를 팔로잉 중인지
    }
    
    // MARK: - Properties
    
    var followerList: [Follower] = [] {
        didSet {
            if currentType == .follower {
                updateView(for: .follower)
            }
        }
    }

    var followingList: [Follower] = [] {
        didSet {
            if currentType == .following {
                updateView(for: .following)
            }
        }
    }
    
    private var currentType: FollowListType = .follower
    
    // MARK: - UI Components
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.separatorStyle = .none
        table.backgroundColor = .white
        table.sectionHeaderHeight = UITableView.automaticDimension
        table.register(FollowListCell.self, forCellReuseIdentifier: FollowListCell.identifier)
        return table
    }()
    
    private let emptyView = FollowListEmptyView()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Mock
        followerList = [
            Follower(id: 1, nickname: "닉네임이지롱1", isFollowing: true, isFollowed: true),
            Follower(id: 2, nickname: "닉네임이지롱2", isFollowing: true, isFollowed: true),
            Follower(id: 3, nickname: "닉네임이지롱3", isFollowing: false, isFollowed: true)
        ]
        
        followingList = [
            Follower(id: 4, nickname: "닉네임이지롱4", isFollowing: true, isFollowed: true),
            Follower(id: 5, nickname: "닉네임이지롱5", isFollowing: true, isFollowed: false)
        ]
        
        setUI()
        setLayout()
        setDelegate()
        updateView(for: currentType)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    override func setUI() {
        addSubviews(tableView, emptyView)
    }
    
    override func setLayout() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Private Methods
    
    public func updateView(for type: FollowListType) {
        currentType = type
        switch currentType {
        case .follower:
            emptyView.configure(type: .follower)
            emptyView.isHidden = !followerList.isEmpty
            tableView.isHidden = followerList.isEmpty
        case .following:
            emptyView.configure(type: .following)
            emptyView.isHidden = !followingList.isEmpty
            tableView.isHidden = followingList.isEmpty
        }
        
        tableView.reloadData()
    }
}

// MARK: - Extensions

extension FollowListView {
    private func setDelegate() {
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func buttonTapped(at index: Int) {
        switch currentType {
        case .follower:
            var user = followerList[index]
            // 팔로잉 <-> 맞팔로우
            if user.isFollowing && user.isFollowed {
                user.isFollowing = false
            } else if !user.isFollowing && user.isFollowed {
                user.isFollowing = true
            }
            followerList[index] = user

        case .following:
            var user = followingList[index]
            // 팔로잉 <-> 팔로우
            if user.isFollowing {
                user.isFollowing = false
            } else {
                user.isFollowing = true
            }
            followingList[index] = user
        }

        let indexPath = IndexPath(row: index, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

extension FollowListView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentType {
        case .follower:
            return followerList.count
        case .following:
            return followingList.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FollowListCell.identifier, for: indexPath) as? FollowListCell else {
            return UITableViewCell()
        }
        
        let user: Follower
        
        switch currentType {
        case .follower:
            user = followerList[indexPath.row]
        case .following:
            user = followingList[indexPath.row]
        }
        
        cell.nickname.text = user.nickname
        
        var state: FollowButton.FollowButtonState = .follow
        
        switch currentType {
        case .follower: // 나를 팔로우하는 사람들 목록
            if user.isFollowing && user.isFollowed {
                state = .following
            } else if !user.isFollowing && user.isFollowed {
                state = .mutualFollow
            }
        case .following: // 내가 팔로잉한 사람들 목록
            state = user.isFollowing ? .following : .follow
        }
        
        cell.button.configure(state: state, size: .short)
        cell.delegate = self
        
        return cell
    }
}

extension FollowListView: FollowListCellDelegate {
    @MainActor
    func followButtonTapped(cell: FollowListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        buttonTapped(at: indexPath.row)
    }
}


#Preview {
    FollowListView()
}
