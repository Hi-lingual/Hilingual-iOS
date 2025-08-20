//
//  FeedSearchViewController.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 8/20/25.
//

import UIKit
import Combine

public final class FeedSearchViewController: BaseUIViewController<FeedSearchViewModel> {
    
    // MARK: - UI Components
    
    private let feedSearchView = FeedSearchView() // 테이블 뷰
    private let feedSearchEmptyView = FeedSearchEmptyView()
    
    // MARK: - Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
    }
    
    // MARK: - Setup Methods
    
    public override func setUI() {
        view.addSubview(feedSearchEmptyView)
    }
    
    public override func setLayout() {
        feedSearchEmptyView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(242)
            $0.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Navigation
    
    public override func navigationType() -> NavigationType? {
        return .backSearchBar(placeholder: "닉네임을 입력해주세요.")
    }
    
    @objc public override func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
