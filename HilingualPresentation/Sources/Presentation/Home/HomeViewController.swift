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
            super.setUI()
            view.addSubview(homeView)
            
            let today = Date()
            homeView.calendarView.selectedDate = today
            homeView.selectedInfo.setSelectedDate(today)
        }

    public override func setLayout() {
        homeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
