//
//  WeekdaySelectorView.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 9/6/26.
//

import UIKit
import SnapKit

final class WeekdaySelectorView: UIView {

    // MARK: - Properties

    private(set) var selectedWeekdays: Set<Int> = []
    var onSelectionChanged: ((Set<Int>) -> Void)?

    private let chips: [WeekdayChipView] = {
        let titles = ["일", "월", "화", "수", "목", "금", "토"]
        return titles.enumerated().map { index, title in
            WeekdayChipView(weekday: index + 1, title: title)
        }
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: chips)
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        return stack
    }()

    // MARK: - Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stackView)
        stackView.snp.makeConstraints { $0.edges.equalToSuperview() }
        chips.forEach { chip in
            chip.onTap = { [weak self] weekday in self?.toggle(weekday) }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public

    func setSelectedWeekdays(_ weekdays: Set<Int>) {
        selectedWeekdays = weekdays
        chips.forEach { $0.setSelected(weekdays.contains($0.weekday)) }
    }

    func setInteractive(_ isInteractive: Bool) {
        chips.forEach { $0.setInteractive(isInteractive) }
    }

    // MARK: - Private

    private func toggle(_ weekday: Int) {
        if selectedWeekdays.contains(weekday) {
            selectedWeekdays.remove(weekday)
        } else {
            selectedWeekdays.insert(weekday)
        }
        chips.first(where: { $0.weekday == weekday })?.setSelected(selectedWeekdays.contains(weekday))
        onSelectionChanged?(selectedWeekdays)
    }
}
