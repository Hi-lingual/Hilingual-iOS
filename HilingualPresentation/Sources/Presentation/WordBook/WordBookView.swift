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
        let placeholderText = "단어나 표현을 검색해주세요"
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray400,
            .font: UIFont.suit(.body_m_16)
        ]
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)

        return searchBar
    }()

    private let statusStackView = UIStackView()

    let totalCountLabel: UILabel = {
        let label = UILabel()
        label.text = "총 0개"
        label.textColor = .gray500
        label.font = .suit(.body_m_14)
        return label
    }()

    let sortButton: UIButton = {
        let button = UIButton()
        button.setTitle("↑ 최신순", for: .normal)
        button.setTitleColor(.gray500, for: .normal)
        button.titleLabel?.font = .suit(.body_m_14)
        return button
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

    let emptyView: UIView = {
        let view = UIView()
        view.isHidden = true

        let emptyImageView = UIImageView()
        emptyImageView.image = UIImage(named: "img_word_ios", in: .module, compatibleWith: nil)
        emptyImageView.contentMode = .scaleAspectFit

        let emptyLabel = UILabel()
        emptyLabel.text = "아직 단어가 추가되지 않았어요."
        emptyLabel.font = .suit(.head_m_18)
        emptyLabel.textColor = .gray500
        emptyLabel.textAlignment = .center

        let emptyButton = CTAButton(style: .TextButton("일기 쓰고 단어 추가하기"), autoBackground: false)

        view.addSubviews(emptyImageView,emptyLabel,emptyButton)

        emptyImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }

        emptyLabel.snp.makeConstraints {
            $0.top.equalTo(emptyImageView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }

        emptyButton.snp.makeConstraints {
            $0.top.equalTo(emptyLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        return view
    }()

    // MARK: - Setup

    override func setUI() {
        navigationContainer.backgroundColor = .black
        statusStackView.axis = .horizontal
        statusStackView.distribution = .equalSpacing
        statusStackView.alignment = .center
        statusStackView.addArrangedSubview(totalCountLabel)
        statusStackView.addArrangedSubview(sortButton)

        addSubviews(
            navigationContainer,
            statusStackView,
            tableView,
            emptyView
        )

        navigationContainer.addSubviews(
            titleLabel,
            searchBar
        )
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

        statusStackView.snp.makeConstraints {
            $0.top.equalTo(navigationContainer.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(statusStackView.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        emptyView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(statusStackView.snp.bottom).offset(80)
            $0.horizontalEdges.equalToSuperview().inset(100)
        }
    }

}
