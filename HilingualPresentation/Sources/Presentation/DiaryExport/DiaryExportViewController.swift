//
//  DiaryExportViewController.swift
//  HilingualPresentation
//
//  Created by 진소은 on 10/16/26.
//

import UIKit
import SnapKit

public final class DiaryExportViewController: BaseUIViewController<DiaryExportViewModel> {

    // MARK: - Properties

    private let diaryId: Int
    private let data: DiaryViewData
    private let topic: String

    // MARK: - UI Components

    private let exportView = DiaryExportView()

    // MARK: - Init

    public init(
        viewModel: DiaryExportViewModel,
        diContainer: ViewControllerFactory,
        diaryId: Int,
        data: DiaryViewData,
        topic: String
    ) {
        self.diaryId = diaryId
        self.data = data
        self.topic = topic
        super.init(viewModel: viewModel, diContainer: diContainer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    // MARK: - Custom Method

    public override func setUI() {
        view.backgroundColor = .gray100
        view.addSubview(exportView)

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance

        exportView.setTopic(topic)
        exportView.setDate(DisplayDateFormatter.diaryExportDate(apiDate: data.apiDate))
        exportView.configure(
            image: data.imageURL,
            originalText: data.originalText,
            highlightText: data.rewriteText,
            diffRanges: data.diffRanges,
            isHighlightingEnabled: true
        )
    }

    public override func setLayout() {
        exportView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    // MARK: - Navigation

    public override func navigationType() -> NavigationType? {
        .closeTitleMenu(title: "일기 카드 미리보기", rightIconName: "ic_export_24_gray500_ios")
    }

    @objc public override func menuButtonTapped() {
        // TODO: 외부 공유 액션 구현
    }
}
