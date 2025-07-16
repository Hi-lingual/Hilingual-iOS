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

    private let navigationContainer = UIView()

    let refreshControl = UIRefreshControl()

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
        searchBar.searchTextField.font = .suit(.body_m_16)
        searchBar.updateHeight(height: 46)
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray400,
            .font: UIFont.suit(.body_m_16)
        ]
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "단어나 표현을 검색해주세요",
            attributes: attributes
        )
        return searchBar
    }()

    let totalCountLabel: UILabel = {
        let label = UILabel()
        label.text = "총 0개"
        label.textColor = .gray500
        label.font = .suit(.body_m_14)
        return label
    }()

    let sortButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "ic_list_24_ios", in: .module, compatibleWith: nil)?
            .withRenderingMode(.alwaysTemplate)

        button.setImage(image, for: .normal)
        button.setTitle("최신순", for: .normal)
        button.tintColor = .gray500
        button.setTitleColor(.gray500, for: .normal)
        button.titleLabel?.font = .suit(.body_m_14)
        button.contentHorizontalAlignment = .right
        button.semanticContentAttribute = .forceLeftToRight
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -2, bottom: 0, right: 2)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: -2)
        return button
    }()

    private lazy var statusHeaderView: UIView = {
        let container = UIView()
        container.backgroundColor = .clear

        let stack = UIStackView(arrangedSubviews: [totalCountLabel, sortButton])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing

        container.addSubview(stack)
        stack.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        return container
    }()

    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.separatorStyle = .none
        table.backgroundColor = .gray100
        table.sectionHeaderHeight = UITableView.automaticDimension
        table.estimatedSectionHeaderHeight = 44
        table.register(WordBookCell.self, forCellReuseIdentifier: WordBookCell.identifier)
        table.register(WordBookHeaderView.self, forHeaderFooterViewReuseIdentifier: WordBookHeaderView.identifier)
        return table
    }()

    let emptyView = WordBookEmptyView()

    // MARK: - Private Properties

    private let sortOptions = ["최신순", "A-Z순"]

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()

        let headerSize = statusHeaderView.systemLayoutSizeFitting(CGSize(
            width: bounds.width,
            height: UIView.layoutFittingCompressedSize.height
        ))
        statusHeaderView.frame = CGRect(origin: .zero, size: headerSize)
        tableView.tableHeaderView = statusHeaderView
    }

    override func setUI() {
        navigationContainer.backgroundColor = .hilingualBlack

        addSubviews(
            navigationContainer,
            tableView,
            emptyView
        )

        navigationContainer.addSubviews(
            titleLabel,
            searchBar
        )

        tableView.refreshControl = refreshControl
    }

    override func setLayout() {
        navigationContainer.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(searchBar.snp.bottom).offset(12)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(12)
            $0.leading.equalToSuperview().offset(16)
        }

        searchBar.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(17)
            $0.leading.trailing.equalToSuperview().inset(8)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationContainer.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        emptyView.snp.makeConstraints {
            $0.top.equalTo(navigationContainer.snp.bottom).offset(120)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    // MARK: - Public Method

    func updateHeaderView(totalCount: Int, sortIndex: Int) {
        totalCountLabel.text = "총 \(totalCount)개"
        if sortOptions.indices.contains(sortIndex) {
            sortButton.setTitle(sortOptions[sortIndex], for: .normal)
        } else {
            sortButton.setTitle(nil, for: .normal)
        }
    }
}
