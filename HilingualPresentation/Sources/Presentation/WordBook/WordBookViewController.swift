//
//  WordBookViewController.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import UIKit
import Combine

public final class WordBookViewController: BaseUIViewController<WordBookViewModel> {

    // MARK: - Properties

    private let wordBookView = WordBookView()
    private var fullWordList: [(String, [PhraseData])] = []
    private var filteredWordList: [(String, [PhraseData])] = []

    public override func loadView() {
        self.view = wordBookView
    }

    public override func setDelegate() {
        wordBookView.tableView.dataSource = self
        wordBookView.tableView.delegate = self
        wordBookView.searchBar.delegate = self
    }

    public override func bind(viewModel: WordBookViewModel) {
        let input = WordBookViewModel.Input(viewDidLoad: Just(()).eraseToAnyPublisher())
        let output = viewModel.transform(input: input)

        output.wordList
            .receive(on: RunLoop.main)
            .sink { [weak self] wordList in
                self?.fullWordList = wordList
                self?.filteredWordList = wordList
                self?.wordBookView.tableView.reloadData()
            }
            .store(in: &cancellables)
    }

    private func filterWords(for keyword: String) {
        guard !keyword.isEmpty else {
            filteredWordList = fullWordList
            wordBookView.tableView.reloadData()
            return
        }

        filteredWordList = fullWordList.compactMap { (date, items) in
            let filtered = items.filter {
                $0.phrase.lowercased().contains(keyword.lowercased())
            }
            return filtered.isEmpty ? nil : (date, filtered)
        }
        wordBookView.tableView.reloadData()
    }
}

// MARK: - UITableView\\Delegate

extension WordBookViewController: UITableViewDataSource, UITableViewDelegate {

    public func numberOfSections(in tableView: UITableView) -> Int {
        return filteredWordList.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredWordList[section].1.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: WordBookCell.identifier,
            for: indexPath
        ) as? WordBookCell else {
            return UITableViewCell()
        }

        let item = filteredWordList[indexPath.section].1[indexPath.row]
        cell.configure(with: item, type: .withDate)
        return cell
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: WordBookHeaderView.identifier
        ) as? WordBookHeaderView else {
            return nil
        }

        header.configure(title: filteredWordList[section].0)
        return header
    }
}

// MARK: - UISearchBarDelegate

extension WordBookViewController: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterWords(for: searchText)
    }

    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
