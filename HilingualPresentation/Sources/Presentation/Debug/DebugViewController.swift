//
//  DebugViewController.swift
//  HilingualPresentation
//
//  Created by 성현주 on 6/27/26.
//


#if DEBUG
import UIKit
import SnapKit

public final class DebugViewController: UIViewController {

    private struct Item {
        let title: String
        let subtitle: String
        let make: () -> UIViewController
    }

    private let items: [Item] = [
        Item(
            title: "강제 에러",
            subtitle: "화면별 서버/네트워크/데이터없음 에러 강제",
            make: { DebugForceErrorViewController() }
        )
    ]

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "디버그"
        view.backgroundColor = .systemGroupedBackground
        setupTableView()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - Setup

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DebugMenuCell")
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension DebugViewController: UITableViewDataSource, UITableViewDelegate {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DebugMenuCell", for: indexPath)
        let item = items[indexPath.row]
        var config = cell.defaultContentConfiguration()
        config.text = item.title
        config.secondaryText = item.subtitle
        cell.contentConfiguration = config
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(items[indexPath.row].make(), animated: true)
    }
}
#endif
