//
//  DiaryDetailViewController.swift
//  HilingualPresentation
//
//  Created by 진소은 on 7/8/25.
//

import Foundation
import UIKit
import SafariServices

public final class DiaryDetailViewController: BaseUIViewController<DiaryDetailViewModel> {
    
    // MARK: - Properties
    
    let diaryId: Int
    var date: String = ""
    
    private let diaryDetailView = DiaryDetailView()
    private var isHighlightingEnabled: Bool = true
    private lazy var dialog = Dialog()
    private let detailImage = DetailImageView(image: UIImage(resource: .imgLoadFailLargeIos))
    
    private let bottomSafeAreaBackgroundView = UIView()
    
    let modal: Modal = {
        let modal = Modal()
        modal.isHidden = true
        return modal
    }()
    
    private lazy var vc1 = diContainer.makeFeedbackViewController(diaryId: diaryId)
    private lazy var vc2 = diContainer.makeVocaViewController(diaryId: diaryId)
    
    private var segmentedControl: SegmentedControl!
    
    // MARK: - Init
    
    public init(viewModel: DiaryDetailViewModel, diContainer: ViewControllerFactory, diaryId: Int) {
        self.diaryId = diaryId
        super.init(viewModel: viewModel, diContainer: diContainer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
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
        
        vc1.onDateLoaded = { [weak self] date in
            self?.vc2.setDate(date)
        }
    }
    
    // MARK: - Custom Method
    
    public override func setUI() {
        view.addSubviews(diaryDetailView, modal, dialog, bottomSafeAreaBackgroundView)
        view.bringSubviewToFront(modal)
        bottomSafeAreaBackgroundView.backgroundColor = .gray100
    }
    
    public override func setLayout() {
        diaryDetailView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        modal.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        dialog.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let bottomInset = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 34
        bottomSafeAreaBackgroundView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(bottomInset)
        }
    }
    
    public override func navigationType() -> NavigationType? {
        return .backTitleMenu("일기장")
    }
    
    @objc public override func backButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Actions
    
    public override func menuButtonTapped() {
        showModal()
    }
    
    @objc private func showModal() {
        modal.configure(
            title: "AI 피드백",
            items: [
                ("신고하기", UIImage(resource: .icReport24Ios), { [weak self] in
                    self?.modal.isHidden = true
                    self?.showDialog()
                })
            ]
        )
        modal.isHidden = false
        
        DispatchQueue.main.async { [weak self] in
            self?.modal.showAnimation()
        }
    }
    
    @objc private func showDialog() {
        dialog.configure(
            title: "AI 피드백을 신고하시겠어요?",
            content: "신고된 AI 피드백은 확인 후\n서비스의 운영원칙에 따라 처리됩니다.",
            leftButtonTitle: "취소",
            rightButtonTitle: "네, 신고할게요"
        )
        
        dialog.showAnimation()
        
        dialog.leftButton.removeTarget(nil, action: nil, for: .allEvents)
        dialog.leftButton.addAction(UIAction { [weak self] _ in
            self?.dialog.dismiss()
        }, for: .touchUpInside)
        
        dialog.rightButton.removeTarget(nil, action: nil, for: .allEvents)
        dialog.rightButton.addAction(UIAction { [weak self] _ in
            self?.dialog.dismiss()
            guard let url = URL(string: "https://hilingual.notion.site/230829677ebf801c965be24b0ef444e9") else { return }
            let safariVC = SFSafariViewController(url: url)
            self?.present(safariVC, animated: true, completion: nil)
        }, for: .touchUpInside)
    }
}
