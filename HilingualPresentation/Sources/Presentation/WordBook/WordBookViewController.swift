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
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        wordBookView.searchBar.text = ""
        wordBookView.searchBar.resignFirstResponder()
        wordBookView.showHeaderView(true)
        selectedSortIndex = 0
        wordBookView.tableView.contentInset.top = 0
        sortSubject.send(.latest)
        wordBookView.updateHeaderView(totalCount: fullWordList.reduce(0) { $0 + $1.1.count }, sortIndex: selectedSortIndex)
        refreshSubject.send(())
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async { [weak self] in
            guard let self = self,
                  let window = self.view.window ?? UIApplication.shared.windows.first else { return }

            modal.isHidden = true
            window.addSubview(modal)
            modal.snp.makeConstraints { $0.edges.equalToSuperview() }

            wordDetailDialog.isHidden = true
            window.addSubview(wordDetailDialog)
            wordDetailDialog.snp.makeConstraints { $0.edges.equalToSuperview() }
        }
    }

    // MARK: - Custom Method

    public override func setDelegate() {
        wordBookView.tableView.dataSource = self
        wordBookView.tableView.delegate = self
        wordBookView.searchBar.delegate = self
        wordBookView.searchBar.searchTextField.delegate = self
    }

    public override func addTarget() {
        wordBookView.refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        wordBookView.sortButton.addTarget(self, action: #selector(didTapSort), for: .touchUpInside)
        wordBookView.emptyView.emptyButton.addTarget(self, action: #selector(didTapEmptyAdd), for: .touchUpInside)
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

    // MARK: - Private Methods

    private func updateViewState() {
        let isAllEmpty = fullWordList.allSatisfy { $0.1.isEmpty }
        let isFilteredEmpty = filteredWordList.allSatisfy { $0.1.isEmpty }

        wordBookView.tableView.isHidden = isFilteredEmpty
        wordBookView.emptyView.isHidden = !isFilteredEmpty

        if isFilteredEmpty {
            let state: WordBookEmptyState = isAllEmpty ? .noWords : .noSearchResult
            wordBookView.emptyView.configure(state: state)
        }
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
        modal.dismiss()
    }

    private func filterWords(for keyword: String) {
        let isSearching = !keyword.isEmpty
        wordBookView.showHeaderView(!isSearching)
        wordBookView.tableView.contentInset.top = isSearching ? 16 : 0

        guard isSearching else {
            filteredWordList = fullWordList
            wordBookView.tableView.reloadData()
            updateViewState()
            return
        }

        filteredWordList = fullWordList.compactMap { (date, items) in
            let filtered = items.filter {
                $0.phrase.lowercased().contains(keyword.lowercased())
            }
            return filtered.isEmpty ? nil : (date, filtered)
        }

        wordBookView.tableView.reloadData()
        updateViewState()
    }

    //MARK: - Action Method

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
        tabBarController?.selectedIndex = 0
    }

    @objc
    private func didTapSort() {
        modal.configure(selectedIndex: selectedSortIndex) { [weak self] selected in
            self?.updateSort(by: selected)
        }
        modal.isHidden = false
        modal.showAnimation()
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
        let isSearching = !(wordBookView.searchBar.text ?? "").isEmpty
        if isSearching { return nil }

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

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let isSearching = !(wordBookView.searchBar.text ?? "").isEmpty
        return isSearching ? 0 : UITableView.automaticDimension
    }
}


// MARK: - UISearchBarDelegate

extension WordBookViewController: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterWords(for: searchText)
    }
}

extension WordBookViewController: UITextFieldDelegate {
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
