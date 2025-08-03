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
    
    internal let profileView = ProfileView()
    internal let calendarView = CalendarView()
    internal let selectedInfo = SelectedInfo()
    
    private let spacer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let spacer2: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()
    
    // MARK: - Custom Method
    
    override func setUI() {
        
        backgroundColor = .hilingualBlack
        
        addSubviews(
            profileView,
            calendarView,
            spacer,
            divider,
            selectedInfo,
            spacer2
        )
        bindCalendar()
        
    }
    
    override func setLayout() {
        
        profileView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(46)
        }
        
//        headerView.snp.makeConstraints {
//            $0.top.equalTo(profileView.snp.bottom).offset(12)
//            $0.horizontalEdges.equalToSuperview()
//        }
        
        calendarView.snp.makeConstraints {
            $0.top.equalTo(profileView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview()
        }
        
        spacer.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(16)
        }
        
        divider.snp.makeConstraints {
            $0.top.equalTo(spacer.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(4)
        }
        
        selectedInfo.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
        
        spacer2.snp.makeConstraints {
            $0.top.equalTo(selectedInfo.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
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
