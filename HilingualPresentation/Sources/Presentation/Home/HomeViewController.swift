import Foundation
import UIKit

public final class HomeViewController: BaseUIViewController<HomeViewModel> {

    // MARK: - Properties

    private let homeView = HomeView()
    private let input = HomeViewModel.Input()
    private var didSendInitialMonth = false

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

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)

        // 월 정보 다시 요청 (최초에도!)
        let selectedDate = homeView.calendarView.selectedDate ?? Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: selectedDate)
        let month = calendar.component(.month, from: selectedDate)
        input.monthChange.send((year, month))
    }
    
    // MARK: - Bind

    public override func bind(viewModel: HomeViewModel) {
        let today = Date()
        homeView.calendarView.selectedDate = today
        homeView.calendarView.reload(for: today)
        homeView.selectedInfo.setSelectedDate(today)

        // 월이 변경되면 1일로 이동 + ViewModel에 전달
        homeView.onMonthChanged = { [weak self] year, month in
            guard let self else { return }

            var components = DateComponents()
            components.year = year
            components.month = month
            components.day = 1

            guard let firstDayOfMonth = Calendar.current.date(from: components) else { return }

            // 해당 월 1일로 이동
            self.homeView.calendarView.select(date: firstDayOfMonth)

            // ViewModel에 새로운 월 정보 전달
            self.input.monthChange.send((year, month))
        }

        let output = viewModel.transform(input: input)

        // 사용자 정보 바인딩
        output.userInfo
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] entity in
                self?.homeView.profileView.updateView(
                    nickname: entity.nickname,
                    profileImageURL: entity.profileImg,
                    totalDiaries: entity.totalDiaries,
                    streak: entity.streak
                )
            })
            .store(in: &viewModel.cancellables)

        // filledDates를 calendarView에 반영 + 선택한 날짜 일기/주제 보여줌
        output.filledDates
            .receive(on: RunLoop.main)
            .sink { [weak self] dates in
                guard let self else { return }
                self.homeView.calendarView.filledDates = dates

                let selected = self.homeView.calendarView.selectedDate ?? Date()
                self.homeView.calendarView.onDateSelected?(selected)
            }
            .store(in: &viewModel.cancellables)

        // 날짜 선택 시, 일기 존재 여부에 따라 fetchDiary 또는 fetchTopic
        homeView.calendarView.onDateSelected = { [weak self] date in
            guard let self else { return }

            self.homeView.selectedInfo.setSelectedDate(date)

            let isDiaryDate = self.homeView.calendarView.filledDates.contains {
                Calendar.current.isDate($0, inSameDayAs: date)
            }

            if isDiaryDate {
                self.viewModel?.fetchDiary(for: date)
                    .receive(on: RunLoop.main)
                    .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] diary in
                        guard let self else { return }
                        self.homeView.selectedInfo.updateView(
                            for: date,
                            diaryId: diary?.diaryId,
                            remainingTime: 0,
                            topicData: nil,
                            diaryData: diary?.originalText,
                            imageURL: diary?.imageUrl
                        )
                    })
                    .store(in: &self.viewModel!.cancellables)
            } else {
                self.viewModel?.fetchTopic(for: date)
                    .receive(on: RunLoop.main)
                    .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] topic in
                        guard let self else { return }
                        self.homeView.selectedInfo.updateView(
                            for: date,
                            diaryId: nil,
                            remainingTime: topic?.remainingTime ?? 0,
                            topicData: topic.map { ($0.topicKor, $0.topicEn) },
                            diaryData: nil,
                            imageURL: nil
                        )
                    })
                    .store(in: &self.viewModel!.cancellables)
            }
        }
    }

    // MARK: - Action

    public override func addTarget() {
        
        // 주제 카드 눌렀을 때, 일기 작성화면으로 이동
        homeView.selectedInfo.cardTopicView.onTapWriteDiary = { [weak self] in
            guard let self else { return }
            let selectedDate = self.homeView.calendarView.selectedDate
            let topic = self.homeView.selectedInfo.topicData
            self.goToDiaryWritingView(topicData: topic, selectedDate: selectedDate)
        }

        // 일기 프리뷰 눌렀을 때, 상세화면으로 이동
        homeView.selectedInfo.onDiaryPreviewTapped = { [weak self] in
            guard let self,
                  let date = self.homeView.calendarView.selectedDate else { return }

            self.viewModel?.fetchDiary(for: date)
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] diary in
                    guard let self, let diary else { return }
                    self.goToDiaryDetailView(diaryId: diary.diaryId)
                })
                .store(in: &self.viewModel!.cancellables)
        }
    }

    // MARK: - Navigation

    private func goToDiaryWritingView(topicData: (String, String)? = nil, selectedDate: Date? = nil) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        let diaryWritingVC = diContainer.makeDiaryWritingViewController(
            topicData: topicData,
            selectedDate: selectedDate ?? Date()
        )
        diaryWritingVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(diaryWritingVC, animated: true)
    }

    private func goToDiaryDetailView(diaryId: Int) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        let detailVC = diContainer.makeDiaryDetailViewController(diaryId: diaryId)
        detailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
