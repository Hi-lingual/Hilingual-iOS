//
//  LoginOnBoardingView.swift
//  HilingualPresentation
//
//  Created by 성현주 on 2/12/26.
//

import UIKit
import SnapKit

final class LoginOnBoardingView: BaseUIView {

    // MARK: - UI Components

    let skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setAttributedTitle(.pretendard(.body_m_14, text: "건너뛰기"), for: .normal)
        button.setTitleColor(.gray400, for: .normal)
        return button
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .hilingualBlack
        return label
    }()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.decelerationRate = .fast
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(LoginOnBoardingPageCell.self, forCellWithReuseIdentifier: LoginOnBoardingPageCell.cellIdentifier)
        return collectionView
    }()

    private let indicatorView = OnBoardingIndicatorView()

    let nextButton: CTAButton = {
        let button = CTAButton(style: .TextButton("다음"))
        return button
    }()

    // MARK: - Setup

    override func setUI() {
        backgroundColor = .white
        addSubviews(
            skipButton,
            titleLabel,
            collectionView,
            indicatorView,
            nextButton
        )
        indicatorView.configure(count: 4)
    }

    override func setLayout() {
        skipButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(12)
            $0.trailing.equalToSuperview().inset(24)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(65)
            $0.leading.trailing.equalToSuperview().inset(24)
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(376)
        }

        indicatorView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(collectionView.snp.bottom).offset(32)
        }

        nextButton.snp.makeConstraints {
            $0.height.equalTo(58)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(49)
        }
    }

    // MARK: - Public Methods

    func updateTitle(text: String, highlightText: String?) {
        let attributedText = NSMutableAttributedString(
            attributedString: .pretendard(.head_sb_20, text: text, lineBreakMode: .byWordWrapping)
        )

        if let highlightText, !highlightText.isEmpty {
            let nsText = text as NSString
            let highlightRange = nsText.range(of: highlightText)
            if highlightRange.location != NSNotFound {
                attributedText.addAttribute(.foregroundColor, value: UIColor.hilingualOrange, range: highlightRange)
            }
        }

        titleLabel.attributedText = attributedText
    }

    func updateIndicator(currentIndex: Int, animated: Bool = true) {
        indicatorView.update(currentIndex: currentIndex, animated: animated)
    }
}
