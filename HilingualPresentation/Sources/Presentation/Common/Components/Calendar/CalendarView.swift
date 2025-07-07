//
//  CalendarView.swift
//  HilingualPresentation
//
//  Created by 조영서 on 7/7/25.
//

import UIKit
import SnapKit

final class CalendarView: UIView {

    // MARK: - Properties
    
    //CalendarHeaderView한테 알려줌
    var onMonthChanged: ((Date) -> Void)?

    private let calendar = Calendar.current
    private var currentDate = Date()
    private var startOfMonth: Date {
        calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
    }

    private var days: [Date] = []
    var filledDates: [Date] = [] {
        didSet { collectionView.reloadData() }
    }

    private var selectedDate: Date? {
        didSet { collectionView.reloadData() }
    }

    // MARK: - UI Components

    private let containerView = UIView()

    private let weekStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()

    private let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 14
        return layout
    }()

    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.isScrollEnabled = false
        cv.register(CustomCalendarCell.self, forCellWithReuseIdentifier: "CustomCalendarCell")
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        generateDays()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateItemSize()
    }

    // MARK: - Setup Methods

    private func setupUI() {
        addSubview(containerView)
        containerView.addSubview(weekStackView)
        containerView.addSubview(collectionView)

        ["일", "월", "화", "수", "목", "금", "토"].forEach { symbol in
            let label = UILabel()
            label.text = symbol
            label.font = .suit(.body_sb_12)
            label.textAlignment = .center
            label.textColor = symbol == "일" ? .alertRed : (symbol == "토" ? .infoBlue : .gray500)
            weekStackView.addArrangedSubview(label)
        }
    }

    private func setupLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        weekStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(20)
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(weekStackView.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    // MARK: - Private Methods

    private func generateDays() {
        days.removeAll()

        let range = calendar.range(of: .day, in: .month, for: currentDate)!
        let firstOfMonthWeekday = calendar.component(.weekday, from: startOfMonth)
        let firstWeekday = calendar.firstWeekday
        let offset = (firstOfMonthWeekday - firstWeekday + 7) % 7

        // 이전 달 날짜
        if offset > 0 {
            for i in 0..<offset {
                if let date = calendar.date(byAdding: .day, value: -offset + i, to: startOfMonth) {
                    days.append(date)
                }
            }
        }

        // 이번 달 날짜
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                days.append(date)
            }
        }

        // 다음 달 날짜 주 단위 맞춤
        let remainder = days.count % 7
        if remainder > 0 {
            let extra = 7 - remainder
            for i in 1...extra {
                if let date = calendar.date(byAdding: .day, value: i, to: days.last!) {
                    days.append(date)
                }
            }
        }
    }

    private func updateItemSize() {
        let width = containerView.bounds.width / 7
        flowLayout.itemSize = CGSize(width: width, height: 34)
    }

    func reload(for date: Date) {
        currentDate = date
        generateDays()
        collectionView.reloadData()
    }
}

// MARK: - Extensions

extension CalendarView: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCalendarCell", for: indexPath) as! CustomCalendarCell

        let date = days[indexPath.item]
        let day = calendar.component(.day, from: date)
        let isToday = calendar.isDateInToday(date)
        let isSelected = selectedDate != nil && calendar.isDate(selectedDate!, inSameDayAs: date)
        let isFilled = filledDates.contains { calendar.isDate($0, inSameDayAs: date) }
        let isWithinMonth = calendar.isDate(date, equalTo: currentDate, toGranularity: .month)

        cell.configure(
            day: day,
            isToday: isToday,
            isSelected: isSelected,
            isFilled: isFilled,
            isWithinMonth: isWithinMonth
        )

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedDate = days[indexPath.item]
    }
    
    func setSelectedDate(_ date: Date) {
        selectedDate = date
    }
}

#Preview {
    CalendarView()
}
