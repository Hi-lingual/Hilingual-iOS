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

    private let calendar = Calendar.current
    private var currentDate = Date()
    private var startOfMonth: Date {
        calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
    }

    private var days: [Date] = []

    // 특정 날짜에 표시 (dotView)
    var filledDates: [Date] = [] {
        didSet { collectionView.reloadData() }
    }

    // 선택된 날짜에 표시 (bubbleView)
    private var selectedDate: Date? {
        didSet { collectionView.reloadData() }
    }
    
    // 소수점 무조건 올림해서 week 줄 수 계산함
    var rowCount: Int {
        return Int(ceil(Double(days.count) / 7.0))
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

    //다시보자
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

    // 높이 변경 반영
    override func layoutSubviews() {
        super.layoutSubviews()
        CellSize()
    }

    // 동적으로 달력 높이 계산 (줄 수가 매번 다르니까)
    override var intrinsicContentSize: CGSize {
        let rowHeight: CGFloat = 34
        let lineSpacing: CGFloat = 14
        let weekHeight: CGFloat = 20
        let rowCount = self.rowCount
        let totalHeight = weekHeight + CGFloat(rowCount) * rowHeight + CGFloat(max(0, rowCount - 1)) * lineSpacing + 8
        return CGSize(width: UIView.noIntrinsicMetric, height: totalHeight)
    }

    // MARK: - Setup Methods

    private func setupUI() {
        addSubview(containerView)
        containerView.addSubview(weekStackView)
        containerView.addSubview(collectionView)
        
        setupWeekLabels()
    }

    private func setupWeekLabels() {
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
            $0.height.equalTo(15)
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
        // 이번 달 1일이 첫 줄에서 몇 칸 뒤에 시작할지 계산
        let firstCell = (firstOfMonthWeekday - firstWeekday + 7) % 7

        // 앞쪽 이전 달 날짜 채우기
        if firstCell > 0 {
            for i in 0..<firstCell {
                if let date = calendar.date(byAdding: .day, value: -firstCell + i, to: startOfMonth) {
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

        // 뒷부분 담달 날짜 채우기 
        let nextMonth = days.count % 7
        if nextMonth > 0 {
            let extra = 7 - nextMonth
            if let baseDate = calendar.date(byAdding: .day, value: 1, to: days.last!) {
                for i in 0..<extra {
                    if let date = calendar.date(byAdding: .day, value: i, to: baseDate) {
                        days.append(date)
                    }
                }
            }
        }
    }

    // 셀 크기 계산
    private func CellSize() {
        let width = containerView.bounds.width / 7
        flowLayout.itemSize = CGSize(width: width, height: 34)
    }

    // MARK: - 외부 로직들
    
    func reload(for date: Date) {
        currentDate = date
        generateDays()
        collectionView.reloadData()
        invalidateIntrinsicContentSize()
    }

    func moveToNextMonth() {
        if let next = calendar.date(byAdding: .month, value: 1, to: currentDate) {
            reload(for: next)
        }
    }

    func moveToPreviousMonth() {
        if let prev = calendar.date(byAdding: .month, value: -1, to: currentDate) {
            reload(for: prev)
        }
    }

    func setSelectedDate(_ date: Date) {
        selectedDate = date
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
}

@available(iOS 17.0, *)
#Preview {
    CalendarView()
}
