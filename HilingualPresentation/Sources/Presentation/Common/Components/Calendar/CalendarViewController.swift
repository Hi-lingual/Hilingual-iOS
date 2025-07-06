import UIKit
import SnapKit

final class CalendarViewController: UIViewController {

    // MARK: - Properties

    private let calendarView = CalendarView()
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("다음 달 ▶️", for: .normal)
        return button
    }()
    private let prevButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("◀️ 이전 달", for: .normal)
        return button
    }()

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
        view.addSubview(nextButton)
        view.addSubview(prevButton)

        nextButton.addTarget(self, action: #selector(nextMonthTapped), for: .touchUpInside)
        prevButton.addTarget(self, action: #selector(prevMonthTapped), for: .touchUpInside)
    }

    private func setupLayout() {
        calendarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        nextButton.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom).offset(16)
            $0.trailing.equalTo(calendarView)
        }

        prevButton.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom).offset(16)
            $0.leading.equalTo(calendarView)
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

    // MARK: - Actions

    @objc private func nextMonthTapped() {
        calendarView.moveToNextMonth()
    }

    @objc private func prevMonthTapped() {
        calendarView.moveToPreviousMonth()
    }
}

@available(iOS 17.0, *)
#Preview {
    CalendarViewController()
}
