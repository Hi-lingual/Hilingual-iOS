//
//  FollowListView.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 8/15/25.
//

import UIKit

final class FollowListView: BaseUIView {
    
    // MARK: - Properties
    
    // TODO: Mock 데이터 삭제
//    var followerList: [Follower] = [] {
//        didSet { updateView(for: .follower) }
//    }
//    
//    var followingList: [Follower] = [] {
//        didSet { updateView(for: .following) }
//    }
    
    // MARK: - UI Components
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.separatorStyle = .none
        table.backgroundColor = .white
        table.estimatedSectionHeaderHeight = 44
        table.sectionHeaderHeight = UITableView.automaticDimension
        table.register(FollowListCell.self, forCellReuseIdentifier: FollowListCell.identifier)
        return table
    }()
    
    private let emptyView = FollowListEmptyView()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setLayout()
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
    
//    private func updateView(for type: FollowListType) {
//        switch type {
//        case .follower:
//            if followerList.isEmpty {
//                tableView.isHidden = true
//                emptyView.isHidden = false
//                emptyView.configure(type: .follower)
//            } else {
//                tableView.isHidden = false
//                emptyView.isHidden = true
//            }
//        case .following:
//            if followingList.isEmpty {
//                tableView.isHidden = true
//                emptyView.isHidden = false
//                emptyView.configure(type: .following)
//            } else {
//                tableView.isHidden = false
//                emptyView.isHidden = true
//            }
//        }
//    }
}
