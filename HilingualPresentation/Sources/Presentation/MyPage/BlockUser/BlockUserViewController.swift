//
//  BlockUserViewController.swift
//  HilingualPresentation
//
//  Created by 성현주 on 8/21/25.
//

import UIKit
import Combine

public final class BlockUserViewController: BaseUIViewController<BlockUserViewModel> {

    // MARK: - Properties

    private let blockUserView = BlockUserView()

    private var unblockTappedSubject = PassthroughSubject<Int, Never>()
    private var refreshTriggeredSubject = PassthroughSubject<Void, Never>()

    // MARK: - Life Cycle

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    //MARK: - Custom Method

    public override func loadView() {
        self.view = blockUserView
    }

    public override func setDelegate() {
        blockUserView.tableView.dataSource = self
        blockUserView.tableView.delegate = self
    }

    public override func navigationType() -> NavigationType? {
        return .backTitle("차단한 유저")
    }

    // MARK: - Bind

    public override func bind(viewModel: BlockUserViewModel) {

        let input = BlockUserViewModel.Input(
            viewDidLoad: Just(()).eraseToAnyPublisher(),
            unblockTapped: unblockTappedSubject.eraseToAnyPublisher(),
            refreshTriggered: refreshTriggeredSubject.eraseToAnyPublisher()
        )

        let output = viewModel.transform(input: input)

        output.blockedUsers
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.blockUserView.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

//MARK: TableView Extension
extension BlockUserViewController: UITableViewDataSource, UITableViewDelegate {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.blockedUsersSubject.value.count ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: BlockedUserCell.identifier,
            for: indexPath
        ) as? BlockedUserCell,
        let user = viewModel?.blockedUsersSubject.value[indexPath.row]
        else {
            return UITableViewCell()
        }

        cell.configure(with: user)

        cell.unblockTapped
            .sink { [weak self] userId in
                self?.unblockTappedSubject.send(userId)
            }
            .store(in: &cancellables)

        return cell
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
