//
//  FollowingListViewController.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 8/16/25.
//

import UIKit
import Combine

public final class FollowingListViewController: BaseUIViewController<FollowListViewModel> {
    
    private let followListView = FollowListView()
    
    private var tableView: UITableView {
        return followListView.tableView
    }
    
    // MARK: - Life Cycle
    
    public override func loadView() {
        self.view = followListView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        bindViewModel()
    }
    
    // MARK: - Setup Methods
    
    private func setupUI() {
        view.addSubview(followListView)
    }
    
    private func setupLayout() {
        followListView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    public override func setDelegate() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - Bind
    
    private func bindViewModel() {
        viewModel?.output.followingList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] users in
                let model = FollowListModel(type: .following, users: users)
                self?.followListView.followListModel = model
            }
            .store(in: &cancellables)
    }
}

// MARK: - UITableViewDataSource

extension FollowingListViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.followingList.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FollowListCell.identifier, for: indexPath) as? FollowListCell else {
            return UITableViewCell()
        }
        
        if let user = viewModel?.followingList[indexPath.row] {
            cell.nickname.text = user.nickname
            cell.button.configure(state: user.buttonState, size: .short)
        }
        
        cell.delegate = self
        return cell
    }
}

// MARK: - UITableViewDelegate

extension FollowingListViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
}

// MARK: - FollowListCellDelegate

extension FollowingListViewController: FollowListCellDelegate {
    
    @MainActor
    func followButtonTapped(cell: FollowListCell) {
        guard let indexPath = tableView.indexPath(for: cell),
              let user = viewModel?.followingList[indexPath.row] else { return }
        
        viewModel?.input.followButtonTapped.send(user.userId)
    }
}
