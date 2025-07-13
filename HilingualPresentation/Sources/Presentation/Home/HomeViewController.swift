//
//  HomeViewController.swift
//  HilingualPresentation
//
//  Created by 조영서 on 7/8/25.
//

import Foundation

public final class HomeViewController: BaseUIViewController<HomeViewModel> {

    // MARK: - Properties

    private let homeView = HomeView()

    // MARK: - Custom Method

    public override func setUI() {
        view.addSubviews(homeView)
    }

    public override func setLayout() {
        homeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
//    public override func bind(viewModel: HomeViewModel) {
//        homeView.bind(viewModel: viewModel)
//    }
}
