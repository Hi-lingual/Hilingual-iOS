//
//  CalendarContentView.swift
//  HilingualPresentation
//
//  Created by 조영서 on 8/2/25.
//

import UIKit
import SnapKit

final class CalendarContentView: UICollectionView {

    // MARK: - Properties

    private let calendar = Calendar.current
    private var currentDate = Date()
    private var startOfMonth: Date? {
        calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))
    }

    private var days: [Date] = []
    var filledDates: [Date] = [] {
        didSet { reloadData() }
    }

    var selectedDate: Date? {
        didSet { reloadData() }
    }

    var onDateSelected: ((Date) -> Void)?

    var rowCount: Int {
        return Int(ceil(Double(days.count) / 7.0))
    }

    // MARK: - Initializer

    init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 14
        flowLayout.estimatedItemSize = .zero
        super.init(frame: .zero, collectionViewLayout: flowLayout)

        isScrollEnabled = false
        dataSource = self
        delegate = self
        register(CustomCalendarCell.self, forCellWithReuseIdentifier: "CustomCalendarCell")
        generateDays()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    func reload(for date: Date) {
        currentDate = date
        generateDays()
        DispatchQueue.main.async {
            self.reloadData()
            self.invalidateIntrinsicContentSize()
        }
    }

    func setSelectedDate(_ date: Date) {
        selectedDate = date
    }

    // MARK: - Private Methods

    private func generateDays() {
        days.removeAll()
        
        guard let startOfMonth = startOfMonth else { return }

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
            guard let lastDate = days.last else { return }
            for i in 1...extra {
                if let date = calendar.date(byAdding: .day, value: i, to: lastDate) {
                    days.append(date)
                }
            }
        }
    }

    private func updateItemSize() {
        let width = bounds.width / 7
        guard width > 0 else { return }
        (collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = CGSize(width: width, height: 34)
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        updateItemSize()
    }

    override var intrinsicContentSize: CGSize {
        let rowHeight: CGFloat = 34
        let lineSpacing: CGFloat = 14
        let rowCount = self.rowCount
        let totalHeight = CGFloat(rowCount) * rowHeight + CGFloat(max(0, rowCount - 1)) * lineSpacing
        return CGSize(width: UIView.noIntrinsicMetric, height: totalHeight)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension CalendarContentView: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)
    -> Int {
        return days.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "CustomCalendarCell", for: indexPath
        ) as! CustomCalendarCell
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
        if let selectedDate = selectedDate {
            onDateSelected?(selectedDate)
        }
    }
}
