//
//  DiaryWritingViewController.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 7/8/25.
//

import Foundation

public final class DiaryWritingViewController: BaseUIViewController<DiaryWritingViewModel> {
    
    // MARK: - Properties

    private let diaryWritingView = DiaryWritingView()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method

    public override func setUI() {
        view.addSubviews(diaryWritingView)
    }

    public override func setLayout() {
        diaryWritingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    public override func navigationType() -> NavigationType? {
        return .backTitle("일기 작성하기")
    }
    
    // MARK: - Bind

}
