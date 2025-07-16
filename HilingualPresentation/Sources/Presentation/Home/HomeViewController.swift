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
    }

    public override func setLayout() {
        homeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public override func addTarget() {
        homeView.selectedInfo.cardTopicView.onTapWriteDiary = { [weak self] in
            self?.goToDiaryWritingView()
        }
    }
    
    // MARK: - Bind Method
    
    public override func bind(viewModel: HomeViewModel) {
        let input = HomeViewModel.Input()
        
        let today = Date()
        homeView.calendarView.selectedDate = today
        homeView.calendarView.reload(for: today)
        homeView.selectedInfo.setSelectedDate(today)
        
        let selectedDate = homeView.calendarView.selectedDate ?? Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: selectedDate)
        let month = calendar.component(.month, from: selectedDate)
        input.monthChange.send((year, month))
        
        homeView.onMonthChanged = { year, month in
            input.monthChange.send((year, month))
        }
        
        homeView.calendarView.onDateSelected = { [weak self] date in
            self?.homeView.selectedInfo.setSelectedDate(date)
        }
        
        let output = viewModel.transform(input: input)
        
        output.userInfo
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("유저 정보 조회 실패: \(error.localizedDescription)")
                    }
                },
                receiveValue: { [weak self] entity in
                    self?.homeView.profileView.updateView(
                        nickname: entity.nickname,
                        profileImageURL: entity.profileImg,
                        totalDiaries: entity.totalDiaries,
                        streak: entity.streak
                    )
                }
            )
            .store(in: &viewModel.cancellables)
        
        output.filledDates
            .receive(on: RunLoop.main)
            .sink { [weak self] (dates: [Date]) in
                guard let self else { return }
                self.homeView.calendarView.filledDates = dates
                let selectedDate = self.homeView.calendarView.selectedDate ?? Date()
                self.homeView.calendarView.reload(for: selectedDate)
            }
            .store(in: &viewModel.cancellables)

    }

    // MARK: - Navigation Method
    
    private func goToDiaryWritingView() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        let diaryWritingVC = DiaryWritingViewController(
            viewModel: DiaryWritingViewModel(),
            diContainer: self.diContainer
        )
        navigationController?.pushViewController(diaryWritingVC, animated: true)
    }
}
