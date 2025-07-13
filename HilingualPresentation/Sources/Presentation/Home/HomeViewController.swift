//
//  HomeViewController.swift
//  HilingualPresentation
//
//  Created by 조영서 on 7/8/25.
//

import Foundation

public final class HomeViewController: BaseUIViewController<HomeViewModel> {

    // MARK: - Properties

    private let homeView = HomeView()

    // MARK: - Life Cycle

    public override func setUI() {
        super.setUI()
        view.addSubview(homeView)

        // 임시 프로필 고정
        homeView.profileView.updateView(
            nickname: "영서",
            profileImageURL: nil,
            totalDiaries: 30,
            streak: 15
        )

        // 초기 날짜 설정
        let today = Date()
        homeView.calendarView.selectedDate = today
        homeView.selectedInfo.setSelectedDate(today)

        // 첫 진입 시 today 더미 세팅
        applyDummyData(for: today)

        // 날짜 선택 시마다 상태 업데이트
        homeView.calendarView.onDateSelected = { [weak self] date in
            self?.homeView.selectedInfo.setSelectedDate(date)
            self?.applyDummyData(for: date)
        }
    }

    public override func setLayout() {
        homeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Dummy Data Setter

    private func applyDummyData(for date: Date) {
        let calendar = Calendar.current
        let today = Date()
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        
        if calendar.isDate(date, inSameDayAs: today) {
            // 오늘 → 작성 가능
            homeView.selectedInfo.updateView(
                for: date,
                isWritten: false,
                remainingTime: 120,
                topicData: (
                    kor: "오늘 하루 중 가장 기뻤던 순간은?",
                    en: "What made you happiest today?"
                )
            )
        } else if calendar.isDate(date, inSameDayAs: yesterday) {
            // 어제 → 작성된 일기 프리뷰
            homeView.selectedInfo.updateView(
                    for: date,
                    isWritten: true,
                    remainingTime: 0,
                    createdAt: "2025-07-08T20:15:00",
                    diaryData: "Today was the most stressful day in 2025 for me. It was the team building day at SOPT. I dreaded this day because I didn't know what to expect. The process was complicated and the group(?) was 공개 in that day, so setting the team in advance was impossible. However, after the long team building I was able to be with the people I wanted which was such a relief. I know it's just the start, but I am already excited.",
                )
        } else if calendar.isDate(date, inSameDayAs: tomorrow) {
            // 내일 → 작성 불가
            homeView.selectedInfo.updateView(
                for: date,
                isWritten: false,
                remainingTime: 0
            )
        } else {
            // 그 외 → 일기 없음 + 작성 불가
            homeView.selectedInfo.updateView(
                for: date,
                isWritten: false,
                remainingTime: 0
            )
        }
    }
    // MARK: - Bind
}
