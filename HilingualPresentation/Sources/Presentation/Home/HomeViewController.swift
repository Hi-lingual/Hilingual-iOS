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

    public override func bind(viewModel: HomeViewModel) {
        let today = Date()
        homeView.calendarView.selectedDate = today
        homeView.calendarView.reload(for: today)
        homeView.selectedInfo.setSelectedDate(today)

        homeView.onMonthChanged = { [weak self] year, month in
            self?.input.monthChange.send((year, month))
        }

        let output = viewModel.transform(input: input)

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

        output.filledDates
            .receive(on: RunLoop.main)
            .sink { [weak self] dates in
                self?.homeView.calendarView.filledDates = dates

                let today = Date()
                self?.homeView.calendarView.onDateSelected?(today)
            }
            .store(in: &viewModel.cancellables)


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
