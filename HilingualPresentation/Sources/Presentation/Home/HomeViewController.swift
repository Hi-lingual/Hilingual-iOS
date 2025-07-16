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
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard !didSendInitialMonth else { return }
        didSendInitialMonth = true

        let selectedDate = homeView.calendarView.selectedDate ?? Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: selectedDate)
        let month = calendar.component(.month, from: selectedDate)
        input.monthChange.send((year, month))
    }

    public override func addTarget() {
        homeView.selectedInfo.cardTopicView.onTapWriteDiary = { [weak self] in
            guard let self else { return }
            
            let selectedDate = self.homeView.calendarView.selectedDate
            let topic = self.homeView.selectedInfo.topicData
            
            self.goToDiaryWritingView(topicData: topic, selectedDate: selectedDate)
        }
    }

    // MARK: - Bind Method

    public override func bind(viewModel: HomeViewModel) {
        // 초기 날짜 세팅
        let today = Date()
        homeView.calendarView.selectedDate = today
        homeView.calendarView.reload(for: today)
        homeView.selectedInfo.setSelectedDate(today)

        // 헤더에서 달 변경 시 ViewModel에 전달
        homeView.onMonthChanged = { [weak self] year, month in
            self?.input.monthChange.send((year, month))
        }

        let output = viewModel.transform(input: input)

        // 유저 정보 바인딩
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

        // 채워진 날짜 바인딩
        output.filledDates
            .receive(on: RunLoop.main)
            .sink { [weak self] dates in
                guard let self else { return }
                self.homeView.calendarView.filledDates = dates
            }
            .store(in: &viewModel.cancellables)

        // 날짜 선택 이벤트 처리
        homeView.calendarView.onDateSelected = { [weak self] date in
            guard let self else { return }

            self.homeView.selectedInfo.setSelectedDate(date)

            // 일기 있는 날짜인지 판단
            let isDiaryDate = self.homeView.calendarView.filledDates.contains {
                Calendar.current.isDate($0, inSameDayAs: date)
            }

            if isDiaryDate {
                self.viewModel?.fetchDiary(for: date)
                    .receive(on: RunLoop.main)
                    .sink(receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            print("일기 조회 실패: \(error.localizedDescription)")
                        }
                    }, receiveValue: { [weak self] diary in
                        guard let self, let diary else { return }

                        self.homeView.selectedInfo.updateView(
                            for: date,
                            diaryId: diary.diaryId,
                            remainingTime: 0,
                            topicData: nil,
                            diaryData: diary.originalText,
                            imageURL: diary.imageUrl
                        )

                        self.goToDiaryDetailView(diaryId: diary.diaryId)
                    })
                    .store(in: &self.viewModel!.cancellables)
            } else {
                self.viewModel?.fetchTopic(for: date)
                    .receive(on: RunLoop.main)
                    .sink(receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            print("주제 조회 실패: \(error.localizedDescription)")
                        }
                    }, receiveValue: { [weak self] topic in
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

        homeView.calendarView.onDateSelected?(today)
    }

    // MARK: - Navigation Method

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
