//
//  FeedSearchView.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 8/20/25.
//

import UIKit

final class FeedSearchView: BaseUIView {
    
    // MARK: - Properties
    
    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.separatorStyle = .none
        table.backgroundColor = .white
        table.sectionHeaderHeight = UITableView.automaticDimension
        table.register(FollowListCell.self, forCellReuseIdentifier: FollowListCell.identifier)
        return table
    }()
    
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
        addSubviews(tableView)
    }
    
    override func setLayout() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
