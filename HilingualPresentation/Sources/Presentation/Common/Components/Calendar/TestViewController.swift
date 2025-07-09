//
//  TestViewController.swift
//  HilingualPresentation
//
//  Created by 조영서 on 7/8/25.
//

import UIKit
import SnapKit


final class TestViewController: UIViewController {

    private let headerView = CalendarHeaderView()
    private let calendarView = CalendarView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupLayout()
        bindHeaderToCalendar()
    }

    private func setupUI() {
        view.addSubview(headerView)
        view.addSubview(calendarView)
    }

    private func setupLayout() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }

        calendarView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
    }

    private func bindHeaderToCalendar() {
        headerView.onMonthChanged = { [weak self] newDate in
            self?.calendarView.reload(for: newDate)
        }
    }
}

#Preview {
    TestViewController()
}
