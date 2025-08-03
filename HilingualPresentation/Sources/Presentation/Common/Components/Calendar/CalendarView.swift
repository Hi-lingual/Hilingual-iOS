//
//  CalendarView.swift
//  HilingualPresentation
//
//  Created by 조영서 on 7/7/25.
//

import UIKit
import SnapKit

final class CalendarView: UIView {

    var onDateSelected: ((Date) -> Void)?
    var onMonthChanged: ((Date) -> Void)?

    private var currentDate = Date()
    public var filledDates: [Date] = []

    private let weekStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()

    private let scrollView = UIScrollView()
    private var calendarViews: [CalendarContentView] = []
    private var isAnimatingScroll = false

    private var scrollViewHeightConstraint: Constraint?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        setupCalendarViews()
        configureCalendars(for: currentDate)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupUI() {
        backgroundColor = .white

        addSubview(weekStackView)
        addSubview(scrollView)

        ["일", "월", "화", "수", "목", "금", "토"].forEach { symbol in
            let label = UILabel()
            label.text = symbol
            label.font = .suit(.body_sb_12)
            label.textAlignment = .center
            label.textColor = symbol == "일" ? .alertRed : (symbol == "토" ? .infoBlue : .gray500)
            weekStackView.addArrangedSubview(label)
        }

        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
    }

    private func setupLayout() {
        weekStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(20)
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(weekStackView.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
            scrollViewHeightConstraint = $0.height.equalTo(0).constraint
        }
    }

    private func setupCalendarViews() {
        for _ in 0..<3 {
            let calendarView = CalendarContentView()
            calendarView.onDateSelected = { [weak self] date in
                self?.onDateSelected?(date)
            }
            scrollView.addSubview(calendarView)
            calendarViews.append(calendarView)
        }

        calendarViews[0].snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.bottom.equalToSuperview()
            $0.width.equalToSuperview()
        }

        calendarViews[1].snp.makeConstraints {
            $0.leading.equalTo(calendarViews[0].snp.trailing)
            $0.top.bottom.equalToSuperview()
            $0.width.equalToSuperview()
        }

        calendarViews[2].snp.makeConstraints {
            $0.leading.equalTo(calendarViews[1].snp.trailing)
            $0.top.bottom.equalToSuperview()
            $0.width.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.contentOffset = CGPoint(x: scrollView.bounds.width, y: 0)
    }

    // MARK: - Calendar Config

    private func configureCalendars(for date: Date) {
        let prevMonth = Calendar.current.date(byAdding: .month, value: -1, to: date)!
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: date)!

        calendarViews[0].reload(for: prevMonth)
        calendarViews[1].reload(for: date)
        calendarViews[2].reload(for: nextMonth)

        calendarViews.forEach {
            $0.filledDates = filledDates
        }

        updateScrollViewHeight()
        onMonthChanged?(date)
    }

    // MARK: - Public Methods

    var selectedDate: Date? {
        get { return calendarViews[1].selectedDate }
        set {
            guard let newDate = newValue else { return }
            select(date: newDate)
        }
    }

    func reload(for date: Date) {
        currentDate = date
        configureCalendars(for: currentDate)

        // 여기 추가!
        calendarViews[1].setSelectedDate(date)

        scrollView.setContentOffset(CGPoint(x: scrollView.bounds.width, y: 0), animated: false)
        updateScrollViewHeight()
    }

    func select(date: Date) {
        currentDate = date
        configureCalendars(for: currentDate)

        calendarViews[1].setSelectedDate(date)

        onDateSelected?(date)
        updateScrollViewHeight()
    }

    var filledDatesProxy: [Date] {
        get { filledDates }
        set {
            filledDates = newValue
            calendarViews.forEach { $0.filledDates = newValue }
            updateScrollViewHeight()
        }
    }

    // MARK: - Height Update

    private func updateScrollViewHeight() {
        layoutIfNeeded()
        let contentHeight = calendarViews[1].intrinsicContentSize.height
        scrollViewHeightConstraint?.update(offset: contentHeight)
    }
}

// MARK: - UIScrollViewDelegate

extension CalendarView: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let page = Int(scrollView.contentOffset.x / pageWidth)

        if page == 0 {
            currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate)!
        } else if page == 2 {
            currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate)!
        } else {
            return
        }

        configureCalendars(for: currentDate)
        scrollView.setContentOffset(CGPoint(x: pageWidth, y: 0), animated: false)
        updateScrollViewHeight()
    }
}
