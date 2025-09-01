import Foundation
import UIKit

public final class HomeViewController: BaseUIViewController<HomeViewModel> {

    // MARK: - Properties

    private var overlayView: UIControl?
    private let homeView = HomeView()
    let dialog = Dialog()
    private let input = HomeViewModel.Input()

    // MARK: - Life Cycle

    public override func setUI() {
        super.setUI()
        view.addSubviews(homeView)
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

        // 사용자 정보도 다시 요청
        viewModel?.fetchUserInfo()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] entity in
                self?.homeView.profileView.updateView(
                    nickname: entity.nickname,
                    profileImageURL: entity.profileImg,
                    totalDiaries: entity.totalDiaries,
                    streak: entity.streak
                )
            })
            .store(in: &viewModel!.cancellables)
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
            
            self.homeView.selectedInfo.resetView()

            var components = DateComponents()
            components.year = year
            components.month = month
            components.day = 1

            guard let firstDayOfMonth = Calendar.current.date(from: components) else { return }

            // 해당 월 1일로 이동
            self.homeView.calendarView.select(date: firstDayOfMonth)
            self.homeView.calendarView.onDateSelected?(firstDayOfMonth)

            // ViewModel에 새로운 월 정보 전달
            self.input.monthChange.send((year, month))
        }

        let output = viewModel.transform(input: input)

        // 사용자 정보 바인딩
        output.userInfo
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("🚨 [UserInfo] API 호출 실패: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] entity in
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
                            isPublished: diary?.isPublished,
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
                            isPublished: nil,
                            remainingTime: topic?.remainingTime ?? 0,
                            topicData: topic.map { ($0.topicKor, $0.topicEn) },
                            diaryData: nil,
                            imageURL: nil
                        )
                    })
                    .store(in: &self.viewModel!.cancellables)
            }
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectedInfoTapped))
        homeView.selectedInfo.addGestureRecognizer(tapGesture)
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
        
        // 일기 더보기 버튼 눌렀을 때, 메뉴 토글
        homeView.selectedInfo.onMoreButtonTapped = { [weak self] _ in
            guard let self else { return }
            if self.homeView.selectedInfo.menu.isHidden {
                self.showOverlay()
            } else {
                self.dismissMenu()
            }
        }
        
        homeView.selectedInfo.onMenuAction = { [weak self] action in
            guard let self else { return }
            
            switch action {
            case .publish:
                self.showDialog(for: .publish, selectedDate: self.homeView.calendarView.selectedDate ?? Date()) { _ in }
            case .unpublish:
                self.showDialog(for: .unpublish, selectedDate: self.homeView.calendarView.selectedDate ?? Date()) { _ in }
            case .delete:
                self.showDialog(for: .delete, selectedDate: self.homeView.calendarView.selectedDate ?? Date()) { _ in }
            }
        }
        homeView.profileView.alarmButton.addTarget(self, action: #selector(alarmButtonTapped), for: .touchUpInside)
    }
    
    //MARK: - Private Methods
    
    private func showOverlay() {
        guard let containerView = tabBarController?.view ?? view else { return }

        let overlay = UIControl()
        overlay.backgroundColor = .clear
        overlay.addTarget(self, action: #selector(dismissMenu), for: .touchUpInside)
        containerView.addSubview(overlay)
        overlay.snp.makeConstraints { $0.edges.equalToSuperview() }
        overlayView = overlay

        if homeView.selectedInfo.menu.superview != nil {
            homeView.selectedInfo.menu.removeFromSuperview()
        }
        containerView.addSubview(homeView.selectedInfo.menu)

        homeView.selectedInfo.menu.snp.remakeConstraints {
            $0.top.equalTo(homeView.selectedInfo.moreImageView.snp.bottom).offset(4)
            $0.trailing.equalTo(homeView.selectedInfo.moreImageView.snp.trailing)
            $0.height.equalTo(96)
            $0.width.equalTo(182)
        }

        homeView.selectedInfo.menu.isHidden = false
        containerView.bringSubviewToFront(homeView.selectedInfo.menu)
    }
    
    private func showDialog(for action: MenuAction, selectedDate: Date, completion: @escaping (Bool?) -> Void) {
        guard let containerView = self.tabBarController?.view else { return }

        containerView.addSubview(dialog)
        dialog.snp.remakeConstraints { $0.edges.equalTo(containerView) }
      
        switch action {
        case .publish:
            dialog.configure(
                style: .normal,
                title: "영어 일기를 게시하시겠어요?",
                content: "공유된 일기는 모든 유저에게 게시되며,\n피드에서 확인하실 수 있어요.",
                leftButtonTitle: "아니요",
                rightButtonTitle: "게시하기",
                leftAction: { [weak dialog] in dialog?.dismiss() },
                rightAction: { [weak self] in
                    guard let self else { return }
                    
                    self.viewModel?.fetchDiary(for: selectedDate)
                        .receive(on: RunLoop.main)
                        .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] diary in
                            guard let self, let diary else { return }
                            
                            self.homeView.selectedInfo.updateDiaryState(isPublished: true)
                            self.homeView.selectedInfo.updateMenuState(isPublished: true)
                            self.dialog.dismiss()
                            
                            let toast = ToastMessage()
                            self.view.addSubview(toast)
                            toast.configure(
                                type: .withButton,
                                message: "일기가 게시되었어요!",
                                actionTitle: "피드 보러가기"
                            )
                            
                            toast.action = { [weak self] in
                                guard let self else { return }
                                let vc = self.diContainer.makeSharedDiaryViewController(diaryId: diary.diaryId)
                                self.navigationController?.pushViewController(vc, animated: true)
                                completion(true)
                            }
                        })
                        .store(in: &self.viewModel!.cancellables)
                }
            )
        case .unpublish:
            dialog.configure(
                style: .normal,
                title: "영어 일기를 비공개 하시겠어요?",
                content: "비공개로 전환 시, 해당 일기의\n피드 활동 내역은 모두 사라져요.",
                leftButtonTitle: "아니요",
                rightButtonTitle: "비공개하기",
                leftAction: { [weak dialog] in dialog?.dismiss() },
                rightAction: {[weak self] in
                    self?.homeView.selectedInfo.updateDiaryState(isPublished: false)
                    self?.homeView.selectedInfo.updateMenuState(isPublished: false)
                    self?.dialog.dismiss()
                    
                    let toast = ToastMessage()
                    self?.view.addSubview(toast)
                    toast.configure(type: .basic, message: "일기가 비공개 되었어요.")
                    completion(true)
                }
            )
        case .delete:
            dialog.configure(
                style: .normal,
                title: "영어 일기를 삭제하시겠어요?",
                content: "작성한 일기를 삭제한 날짜에는\n다시 일기를 작성할 수 없어요.",
                leftButtonTitle: "아니요",
                rightButtonTitle: "삭제하기",
                leftAction: { [weak dialog] in dialog?.dismiss() },
                rightAction: { [weak self] in
                    self?.homeView.selectedInfo.updateView(
                        for: self?.homeView.calendarView.selectedDate ?? Date(),
                        diaryId: nil, isPublished: nil,
                        remainingTime: 0,
                        topicData: nil,
                        diaryData: nil,
                        imageURL: nil
                    )
                    self?.dialog.dismiss()
                    completion(true)
                    
                    // TODO: 삭제 API 호출
                }
            )
        }
        dialog.showAnimation()
    }
    
    @objc private func dismissMenu() {
        homeView.selectedInfo.menu.isHidden = true
        overlayView?.removeFromSuperview()
        overlayView = nil
    }

    @objc private func alarmButtonTapped() {
        let notificationVC = diContainer.makeNotificationViewController()
        notificationVC.hidesBottomBarWhenPushed = true

        navigationController?.pushViewController(notificationVC, animated: true)
    }
    
    @objc private func selectedInfoTapped() {
        guard let selectedDate = homeView.calendarView.selectedDate else { return }
        
        if !homeView.selectedInfo.menu.isHidden { return }
        
        let isDiaryDate = homeView.calendarView.filledDates.contains {
            Calendar.current.isDate($0, inSameDayAs: selectedDate)
        }
        
        guard isDiaryDate else { return }
        
        viewModel?.fetchDiary(for: selectedDate)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] diary in
                guard let self, let diary else { return }
                self.goToDiaryDetailView(diaryId: diary.diaryId)
            })
            .store(in: &viewModel!.cancellables)
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
