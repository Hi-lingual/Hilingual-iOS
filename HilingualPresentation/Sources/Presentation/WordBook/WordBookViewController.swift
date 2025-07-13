//
//  WordBookViewController.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import UIKit
import Combine

import HilingualDomain

public final class WordBookViewController: BaseUIViewController<WordBookViewModel> {

    private let wordBookView = WordBookView()
    private var fullWordList: [(String, [PhraseData])] = []
    private var filteredWordList: [(String, [PhraseData])] = []
    private let sortSubject = PassthroughSubject<SortOption, Never>()

    public override func loadView() {
        self.view = wordBookView
        wordBookView.sortButton.addTarget(self, action: #selector(didTapSort), for: .touchUpInside)

        if let emptyButton = wordBookView.emptyView.viewWithTag(999) as? UIButton {
            emptyButton.addTarget(self, action: #selector(didTapEmptyAdd), for: .touchUpInside)
        }
    }

    public override func setDelegate() {
        wordBookView.tableView.dataSource = self
        wordBookView.tableView.delegate = self
        wordBookView.searchBar.delegate = self
    }

    public override func bind(viewModel: WordBookViewModel) {
        let input = WordBookViewModel.Input(
            viewDidLoad: Just(()).eraseToAnyPublisher(),
            sortChanged: sortSubject.eraseToAnyPublisher()
        )

        let output = viewModel.transform(input: input)

        output.wordList
            .receive(on: RunLoop.main)
            .sink { [weak self] wordList in
                self?.fullWordList = wordList
                self?.filteredWordList = wordList
                self?.updateViewState()
                self?.wordBookView.tableView.reloadData()
            }
            .store(in: &cancellables)
    }

    private func updateViewState() {
        let isEmpty = fullWordList.allSatisfy { $0.1.isEmpty }
        wordBookView.tableView.isHidden = isEmpty
        wordBookView.emptyView.isHidden = !isEmpty
    }

    @objc private func didTapSort() {
        let modal = Modal()
        modal.configure(
            title: "정렬 기준 선택",
            items: [
                ("최신순", UIImage(systemName: "arrow.down"), { [weak self] in
                    self?.sortSubject.send(.latest)
                    self?.wordBookView.tableView.reloadData()
                }),
                ("가나다순", UIImage(systemName: "textformat.abc"), { [weak self] in
                    self?.sortSubject.send(.alphabetical)
                    self?.wordBookView.tableView.reloadData()
                })
            ]
        )
        modal.show(in: self.view)
    }

    @objc private func didTapEmptyAdd() {
        print("일기 쓰러 이동") // TODO: push WriteDiaryViewController 등으로 이동
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

extension WordBookViewController: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterWords(for: searchText)
    }

    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
