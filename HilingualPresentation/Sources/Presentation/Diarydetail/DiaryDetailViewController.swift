//
//  DiaryDetailViewController.swift
//  HilingualPresentation
//
//  Created by 진소은 on 7/8/25.
//

import Foundation
import UIKit

public final class DiaryDetailViewController: BaseUIViewController<DiaryDetailViewModel> {
    
    // MARK: - Properties
    
    private let diaryDetailView = DiaryDetailView()
    private var isHighlightingEnabled: Bool = true
    private let toggleButton = UIButton(type: .system)
    
    private lazy var vc1 = diContainer.makeFeedbackViewController()
    private lazy var vc2 = diContainer.makeVocaViewController()
    
    private var segmentedControl : SegmentedControl!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedControl = SegmentedControl(
            viewControllers: [vc1, vc2],
            titles: ["문법·철자", "추천표현"],
            parentViewController: self
        )
        
        diaryDetailView.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(diaryDetailView.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    // MARK: - Custom Method
    
    public override func setUI() {
        view.addSubviews(diaryDetailView, toggleButton)
    }
    
    public override func setLayout() {
        diaryDetailView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    public override func navigationType() -> NavigationType? {
        return .backTitleMenu("일기장")
    }
    
    public override func menuButtonTapped() {
        let modal: Modal = {
            let modal = Modal()
            modal.isHidden = true
            modal.configure(
                title: "AI 피드백",
                items: [
                    ("신고하기", UIImage(resource: .icCamera24Ios), {
                        print("카메라 선택")
                    })
                ]
            )
            return modal
        }()
    }
}
