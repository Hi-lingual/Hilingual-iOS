//
//  WordBookView.swift
//  HilingualPresentation
//
//  Created by 성현주 on 7/11/25.
//

import UIKit
import SnapKit

final class WordBookView: BaseUIView {

    // MARK: - UI Components

    private let navigationContainer: UIView = {
        let container = UIView()
        container.backgroundColor = .black
        return container
    }()


    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "나의 단어장"
        label.textColor = .white
        label.font = .suit(.head_b_18)
        return label
    }()

    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "단어나 표현을 검색해주세요"
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.backgroundColor = .white
        searchBar.searchTextField.layer.cornerRadius = 8
        searchBar.searchTextField.clipsToBounds = true
        return searchBar
    }()

    private let statusStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        return stack
    }()

    let totalCountLabel: UILabel = {
        let label = UILabel()
        label.text = "총 0개"
        label.textColor = .gray500
        label.font = .systemFont(ofSize: 14)
        return label
    }()

    let sortButton: UIButton = {
        let button = UIButton()
        button.setTitle("↑ 최신순", for: .normal)
        button.setTitleColor(.gray500, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        return button
    }()

    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.separatorStyle = .none
        table.backgroundColor = .gray100
        table.register(WordBookCell.self, forCellReuseIdentifier: WordBookCell.identifier)
        table.register(WordBookHeaderView.self, forHeaderFooterViewReuseIdentifier: WordBookHeaderView.identifier)
        table.sectionHeaderHeight = UITableView.automaticDimension
        table.estimatedSectionHeaderHeight = 44
        return table
    }()

    // MARK: - Setup

    override func setUI() {
        statusStackView.addArrangedSubview(totalCountLabel)
        statusStackView.addArrangedSubview(sortButton)

        addSubviews(
            navigationContainer,
            statusStackView,
            tableView
        )

        navigationContainer.addSubviews(
            titleLabel,
            searchBar
        )
    }

    override func setLayout() {
        navigationContainer.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(132)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(52)
            $0.leading.equalToSuperview().offset(16)
        }

        searchBar.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(46)
        }

        statusStackView.snp.makeConstraints {
            $0.top.equalTo(navigationContainer.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(20)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(statusStackView.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
