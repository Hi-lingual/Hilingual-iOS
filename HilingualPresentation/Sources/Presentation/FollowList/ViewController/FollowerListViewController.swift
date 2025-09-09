//
//  FollowerListViewController.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 8/16/25.
//

import UIKit
import Combine

public final class FollowerListViewController: BaseUIViewController<FollowListViewModel> {

    private let followListView = FollowListView()
    private let refreshControl = UIRefreshControl()

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
        setRefreshControl()
        bindViewModel()
        refresh()
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
        viewModel?.followListPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                guard model.type == .follower else { return }
                self?.followListView.followListModel = model
                self?.tableView.reloadData()
                self?.tableView.refreshControl?.endRefreshing()
            }
            .store(in: &cancellables)
    }
    
    private func updateList(_ model: FollowListModel) {
        guard model.type == .follower else { return }

        self.followListView.followListModel = model
        self.tableView.reloadData()
    }
    
    // MARK: - Action
    
    private func setRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc private func refresh() {
        viewModel?.input.fetchFollowers.send(())
        tableView.refreshControl?.endRefreshing()
    }
}

// MARK: - UITableViewDataSource

extension FollowerListViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followListView.followListModel.users.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FollowListCell.identifier, for: indexPath) as? FollowListCell
        else { return UITableViewCell() }

        let user = followListView.followListModel.users[indexPath.row]

        cell.nickname.text = user.nickname
        cell.button.configure(state: user.buttonState)
        cell.delegate = self
        return cell
    }
}

// MARK: - UITableViewDelegate

extension FollowerListViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
}

// MARK: - FollowListCellDelegate

extension FollowerListViewController: FollowListCellDelegate {
    func profileTapped(cell: FollowListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        let user = followListView.followListModel.users[indexPath.row]

        let userFeedVC = diContainer.makeUserFeedProfileViewController(userId: Int64(user.userId))
        userFeedVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(userFeedVC, animated: true)
    }

    @MainActor
    func followButtonTapped(cell: FollowListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let user = followListView.followListModel.users[indexPath.row]
        viewModel?.input.followButtonTapped.send(user.userId)
    }
}
