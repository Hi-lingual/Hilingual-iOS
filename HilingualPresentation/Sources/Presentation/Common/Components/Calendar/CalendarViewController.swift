//
//  CalendarViewController.swift
//  HilingualPresentation
//
//  Created by 조영서 on 7/7/25.
//

import UIKit
import SnapKit

final class CalendarViewController: UIViewController {

    // MARK: - Properties

    private let calendarView = CalendarView()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupLayout()
        setupExampleData()
    }

    // MARK: - Setup Methods

    private func setupUI() {
        view.addSubview(calendarView)
    }

    private func setupLayout() {
        calendarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(300)
        }
    }

    private func setupExampleData() {
        let calendar = Calendar.current
        let today = Date()

        calendarView.reload(for: today)

        if let plus1 = calendar.date(byAdding: .day, value: 1, to: today),
           let plus2 = calendar.date(byAdding: .day, value: 2, to: today) {
            calendarView.filledDates = [today, plus1, plus2]
            calendarView.setSelectedDate(plus1)
        }
    }
}


@available(iOS 17.0, *)
#Preview {
    CalendarViewController()
}
