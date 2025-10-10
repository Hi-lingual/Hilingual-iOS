//
//  HomeView.swift
//  Hilingual
//
//  Created by 조영서 on 7/9/25.
//

import UIKit
import SnapKit

final class HomeView: BaseUIView {
    
    var onMonthChanged: ((Int, Int) -> Void)?
    
    // MARK: - UI Components
    
    private(set) var profileView = ProfileView()
    private(set) var calendarView = CalendarView()
    private(set) var selectedInfo = SelectedInfo()
    
    private let spacer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let bottomBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    // MARK: - Custom Method
    
    override func setUI() {
        backgroundColor = .hilingualBlack
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        
        addSubviews(bottomBackground, scrollView)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubviews(
            profileView,
            calendarView,
            spacer,
            divider,
            selectedInfo
        )
        
        bindCalendar()
    }
    
    override func setLayout() {
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        profileView.snp.makeConstraints {
            $0.top.equalTo(contentView.safeAreaLayoutGuide).inset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(46)
        }
        
        calendarView.snp.makeConstraints {
            $0.top.equalTo(profileView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview()
        }
        
        spacer.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(28)
        }
        
        divider.snp.makeConstraints {
            $0.top.equalTo(spacer.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(4)
        }
        
        selectedInfo.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(16)
        }
        
        bottomBackground.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Binding
    
    private func bindCalendar() {
        calendarView.onDateSelected = { [weak self] date in
            self?.selectedInfo.setSelectedDate(date)
        }

        calendarView.onMonthChanged = { [weak self] date in
            guard let self else { return }
            let calendar = Calendar.current
            let year = calendar.component(.year, from: date)
            let month = calendar.component(.month, from: date)
            self.onMonthChanged?(year, month)
        }
    }
}
