//
//  FollowListView.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 8/15/25.
//

import UIKit

final class FollowListView: BaseUIView {
    
    // MARK: - Properties
    
    private var currentType: FollowListType = .follower
    
    var followListModel: FollowListModel = FollowListModel(type: .follower, users: []) {
        didSet {
            updateView()
        }
    }
    
    // MARK: - UI Components
    
    let tableView: UITableView = {
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
        
        setUI()
        setLayout()
        updateView()
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
    
    private func updateView() {
        let users = followListModel.users
        currentType = followListModel.type
        emptyView.configure(type: currentType)
        
        emptyView.isHidden = !users.isEmpty
        tableView.isHidden = users.isEmpty
        tableView.reloadData()
    }
}

// MARK: - Preview

#Preview {
    FollowListView()
}
