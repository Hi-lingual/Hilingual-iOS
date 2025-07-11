//
//  HomeView.swift
//  Hilingual
//
//  Created by 조영서 on 7/9/25.
//

import UIKit
import SnapKit

final class HomeView: BaseUIView {
    
    // MARK: - UI Components
    
    internal let profileView = ProfileView()
    internal let headerView = CalendarHeaderView()
    internal let calendarView = CalendarView()
    internal let selectedInfo = SelectedInfo()
    
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
    
    // MARK: - Custom Method
        
    override func setUI() {
        
        backgroundColor = .hilingualBlack
        
        addSubviews(
            profileView,
            headerView,
            calendarView,
            spacer,
            divider,
            selectedInfo
        )

        bindCalendar()
    }
        
    override func setLayout() {

        profileView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(46)
        }
                
        headerView.snp.makeConstraints {
            $0.top.equalTo(profileView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview()
        }
        
        calendarView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
        
        spacer.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(12)
        }
        
        divider.snp.makeConstraints {
            $0.top.equalTo(spacer.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(4)
        }
        
        selectedInfo.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Binding

    // 캘린더 하나로 묶기
    private func bindCalendar() {
        headerView.onMonthChanged = { [weak self] newDate in
            self?.calendarView.reload(for: newDate)
        }

        //선택된 날짜 반영
        calendarView.onDateSelected = { [weak self] date in
            self?.selectedInfo.setSelectedDate(date)
        }
    }
}


#Preview {
    let view = HomeView()
    
    view.profileView.updateView(
        nickname: "영돌이",
        profileImageURL: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRkp6rJALpEwmvjDRzTmLZvkIvnItXqRu34BQ&s",
        totalDiaries: 12,
        streak: 4
    )
    
    let today = Date()
    view.selectedInfo.setSelectedDate(today)
    view.selectedInfo.updateView(
        for: today,
        isWritten: false,
        remainingTime: 720,
        topicData: (
            kor: "오늘 당신을 놀라게 한 일이 있었나요?",
            en: "What surprised you today?"
        )
    )

    return view
}
