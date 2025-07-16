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

    // MARK: - View & State

    private let wordBookView = WordBookView()
    private var fullWordList: [(String, [PhraseData])] = []
    private var filteredWordList: [(String, [PhraseData])] = []

    private var selectedSortIndex: Int = 0

    // MARK: - Inputs

    private let sortSubject = PassthroughSubject<SortOption, Never>()
    private let selectedWordIdSubject = PassthroughSubject<Int, Never>()
    private let bookmarkToggledSubject = PassthroughSubject<(Int, Bool), Never>()
    private let refreshSubject = PassthroughSubject<Void, Never>()

    // MARK: - UI Components

    private let modal = SortOptionModal()
    private let wordDetailDialog = WordDetailDialog()

    // MARK: - Lifecycle

    public override func loadView() {
        self.view = wordBookView

        wordBookView.sortButton.addTarget(self, action: #selector(didTapSort), for: .touchUpInside)

        if let emptyButton = wordBookView.emptyView.viewWithTag(999) as? UIButton {
            emptyButton.addTarget(self, action: #selector(didTapEmptyAdd), for: .touchUpInside)
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        wordBookView.refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)

        if let tabView = tabBarController?.view {
            modal.isHidden = true
            tabView.addSubview(modal)
            modal.snp.makeConstraints { $0.edges.equalToSuperview() }

            wordDetailDialog.isHidden = true
            tabView.addSubview(wordDetailDialog)
            wordDetailDialog.snp.makeConstraints { $0.edges.equalToSuperview() }
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
            sortChanged: sortSubject.eraseToAnyPublisher(),
            selectedWordId: selectedWordIdSubject.eraseToAnyPublisher(),
            bookmarkToggled: bookmarkToggledSubject.eraseToAnyPublisher(),
            refreshTriggered: refreshSubject.eraseToAnyPublisher()
        )

        let output = viewModel.transform(input: input)

        output.wordList
            .receive(on: RunLoop.main)
            .sink { [weak self] wordList in
                guard let self = self else { return }
                self.fullWordList = wordList
                self.filteredWordList = wordList
                self.updateViewState()

                let totalCount = wordList.reduce(0) { $0 + $1.1.count }
                self.wordBookView.updateHeaderView(totalCount: totalCount, sortIndex: self.selectedSortIndex)

                self.wordBookView.tableView.reloadData()
            }
            .store(in: &cancellables)

        output.wordDetail
            .receive(on: RunLoop.main)
            .sink { [weak self] detail in
                self?.wordDetailDialog.configure(data: detail)
                self?.wordDetailDialog.onBookmarkToggled = { [weak self] phraseId, isMarked in
                    self?.bookmarkToggledSubject.send((phraseId, isMarked))
                }
                self?.wordDetailDialog.showAnimation()
            }
            .store(in: &cancellables)
    }

    // MARK: - Private Helpers

    private func updateViewState() {
        let isEmpty = fullWordList.allSatisfy { $0.1.isEmpty }
        wordBookView.tableView.isHidden = isEmpty
        wordBookView.emptyView.isHidden = !isEmpty
    }

    @objc
    private func didTapSort() {
        modal.configure(selectedIndex: selectedSortIndex) { [weak self] selected in
            self?.updateSort(by: selected)
        }
        modal.isHidden = false
        modal.showAnimation()
    }

    private func updateSort(by index: Int) {
        selectedSortIndex = index

        switch index {
        case 0:
            sortSubject.send(.latest)
        case 1:
            sortSubject.send(.alphabetical)
        default:
            break
        }

        let totalCount = fullWordList.reduce(0) { $0 + $1.1.count }
        wordBookView.updateHeaderView(totalCount: totalCount, sortIndex: index)

        modal.isHidden = true
    }

    @objc
    private func didPullToRefresh() {
        refreshSubject.send(())
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
            self?.wordBookView.refreshControl.endRefreshing()
        }
    }

    @objc
    private func didTapEmptyAdd() {
        print("일기 쓰러 이동")
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

// MARK: - UITableViewDataSource & UITableViewDelegate

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
        cell.configure(with: item, type: .basic)

        cell.onBookmarkToggled = { [weak self] isMarked in
            self?.bookmarkToggledSubject.send((Int(item.phraseId), isMarked))
        }

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

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = filteredWordList[indexPath.section].1[indexPath.row]
        selectedWordIdSubject.send(Int(item.phraseId))
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
