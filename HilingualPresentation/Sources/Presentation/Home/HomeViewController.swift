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
        
        // 초기 날짜 설정
        let today = Date()
        homeView.calendarView.selectedDate = today
        homeView.selectedInfo.setSelectedDate(today)

        // 날짜 선택 시마다 상태 업데이트
        homeView.calendarView.onDateSelected = { [weak self] date in
            self?.homeView.selectedInfo.setSelectedDate(date)
        }
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
    
    //MARK: - Bind Method
    
    public override func bind(viewModel: HomeViewModel) {
        let output = viewModel.transform(input: .init())

        output.userInfo
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
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
    }


    // MARK: - Navigation Method
    
    private func goToDiaryWritingView() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        let diaryWritingVC = DiaryWritingViewController(viewModel: DiaryWritingViewModel(), diContainer: self.diContainer)
        navigationController?.pushViewController(diaryWritingVC, animated: true)
    }
}
