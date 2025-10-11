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

    private let contentView : UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .hilingualBlack
        return contentView
    }()

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

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .white
        scrollView.bounces = false
        return scrollView
    }()

    // MARK: - Custom Method

    override func setUI() {
        backgroundColor = .hilingualBlack

        addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubviews(
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

        scrollView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width)
        }

        profileView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
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
        }

        spacer2.snp.makeConstraints {
            $0.top.equalTo(selectedInfo.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(16)
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
