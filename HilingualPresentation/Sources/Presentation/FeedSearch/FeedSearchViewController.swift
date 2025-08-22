//
//  FeedSearchViewController.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 8/20/25.
//

import UIKit
import Combine

public final class FeedSearchViewController: BaseUIViewController<FeedSearchViewModel> {
    
    // MARK: - Properties
    
    private let searchBar = SearchBar()
    private var userList: [FeedSearchUserModel] = []
    private let searchTrigger = PassthroughSubject<String, Never>()
    
    // MARK: - UI Components
    
    private let feedSearchView = FeedSearchView()
    private let feedSearchEmptyView = FeedSearchEmptyView()
    private var tableView: UITableView {
        return feedSearchView.tableView
    }
    
    // MARK: - Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
        setDelegate()
        bind(viewModel: FeedSearchViewModel())
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }
    
    // MARK: - Setup Methods
    
    public override func setUI() {
        view.addSubviews(feedSearchView, feedSearchEmptyView)
        
        feedSearchView.isHidden = true
        feedSearchEmptyView.isHidden = true
        
        navigationItem.titleView = searchBar
        searchBar.delegate = self
    }
    
    public override func setLayout() {
        feedSearchView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        feedSearchEmptyView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(242)
            $0.centerX.equalToSuperview()
        }
    }
    
    public override func setDelegate() {
        feedSearchView.tableView.dataSource = self
        feedSearchView.tableView.delegate = self
        searchBar.delegate = self
    }
    
    // MARK: - Bind
    
    public override func bind(viewModel: FeedSearchViewModel) {
        let output = viewModel.transform()

        output.searchState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.updateUI(for: state)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Private Methods
    
    private func updateUI(for state: SearchState) {
        switch state {
        case .enter:
            feedSearchView.isHidden = true
            feedSearchEmptyView.isHidden = true
        case .searchResult(let users):
            self.userList = users
            feedSearchView.isHidden = false
            feedSearchEmptyView.isHidden = true
            feedSearchView.tableView.reloadData()
        case .empty:
            self.userList = []
            feedSearchView.isHidden = true
            feedSearchEmptyView.isHidden = false
            feedSearchView.tableView.reloadData()
        }
    }
    
    // MARK: - Navigation
    
    public override func navigationType() -> NavigationType? {
        return .backSearchBar
    }
    
    @objc public override func backButtonTapped() {
        navigationController?.popViewController(animated: true)
        
        searchBar.text = ""
        userList = []
        feedSearchView.isHidden = true
        feedSearchEmptyView.isHidden = true
        feedSearchView.tableView.reloadData()
        
        viewModel?.input.searchTrigger.send("")
    }
}

// MARK: - UITableViewDataSource

extension FeedSearchViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FollowListCell.identifier, for: indexPath) as? FollowListCell else {
            return UITableViewCell()
        }
        let user = userList[indexPath.row]
        cell.delegate = self
        cell.configure(with: user)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension FeedSearchViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = userList[indexPath.row]
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
}

// MARK: - UISearchBarDelegate

extension FeedSearchViewController: UISearchBarDelegate {
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        searchBar.resignFirstResponder()
        
        viewModel?.input.searchTrigger.send(query)
    }
}

// MARK: - FollowListCellDelegate

extension FeedSearchViewController: FollowListCellDelegate {
    
    @MainActor
    func followButtonTapped(cell: FollowListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        var user = userList[indexPath.row]
        
        user.isFollowing.toggle()
        userList[indexPath.row] = user
        
        cell.configure(with: user)
        
        viewModel?.input.followButtonTapped.send(user.userId)
    }
}
