//
//  HomeViewController.swift
//  Hilingual
//
//  Created by 조영서 on 7/9/25.
//

import UIKit
import Combine
@preconcurrency import GoogleMobileAds

public final class HomeViewController: BaseUIViewController<HomeViewModel> {
    
    // MARK: - Properties
    
    private var hasShownOnboardingBottomSheet = false
    private var isShowingOnboardingBottomSheet = false
    private var onboardingBottomSheet: OnboardingBottomSheet?
    private var overlayView: UIControl?
    private let homeView = HomeView()
    private let homeModal = HomeModal()
    private let updateNoticeModal = HomeModal(buttonLabelStyle: .hidden)
    let dialog = Dialog()
    private let input = HomeViewModel.Input()
    private var currentDateRequestCancellable: AnyCancellable?
    private var pendingDraftDate: Date?
    private var pendingDraftTopic: (String, String)?
    private var pendingDraftIsRecovery = false
    private var pendingRecoveryDate: Date?
    private var recoveryTickets = 0
    private var didLoadFilledDates = false
    private var recoveredDateKeys: Set<String> = []
    private let recoveredDateStorageKey = "home.recoveredDateKeys"
    private let dismissedRecoveryModalMonthStorageKey = "home.dismissedRecoveryModalMonth"
    private let didShowUpdateNoticeModalStorageKey = "home.didShowRecoveryUpdateNoticeModal"
    private let localPushPermissionService = LocalPushPermissionService()
    private var rewardedInterstitial: RewardedInterstitialAd?
    private var didEarnRecoveryReward = false
    private var recoveryTransitionOverlay: UIView?
    
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
        
        loadRecoveredDatesFromStorage()
        refreshUserInfo()
        homeView.selectedInfo.reset()
        
        let selectedDate = homeView.calendarView.selectedDate ?? Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: selectedDate)
        let month = calendar.component(.month, from: selectedDate)
        
        input.monthChange.send((year, month))
        checkAndRequestLocalPushPermission()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !showOnboardingBottomSheet() {
            showNextHomeModal()
        }
    }
    
    // MARK: - Bind
    
    public override func bind(viewModel: HomeViewModel) {
        let today = Date()
        homeView.calendarView.selectedDate = today
        homeView.calendarView.reload(for: today)
        homeView.selectedInfo.setSelectedDate(today)

        homeView.calendarView.onDateSelected = { [weak self] date in
            self?.fetchAndShowDateInfo(for: date)
        }
        
        homeView.onMonthChanged = { [weak self] year, month in
            guard let self else { return }
            
            let calendar = Calendar.current
            let existingSelected = self.homeView.calendarView.selectedDate
            let selectedDate: Date
            if let existingSelected,
               calendar.component(.year, from: existingSelected) == year,
               calendar.component(.month, from: existingSelected) == month {
                selectedDate = existingSelected
            } else {
                selectedDate = calendar.date(from: DateComponents(year: year, month: month, day: 1))!
            }
            
            self.homeView.selectedInfo.updateView(
                for: selectedDate,
                diaryId: nil,
                isPublished: nil,
                remainingTime: 0,
                topicData: nil,
                diaryData: nil,
                imageURL: nil
            )
            
            self.homeView.selectedInfo.reset()
            self.homeView.calendarView.select(date: selectedDate)
            self.fetchAndShowDateInfo(for: selectedDate)
            self.input.monthChange.send((year, month))
        }
        
        let output = viewModel.transform(input: input)
        
        output.userInfo
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("🚨 [UserInfo] API 호출 실패: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] userInfo in
                self?.updateUserInfo(userInfo)
            })
            .store(in: &viewModel.cancellables)
        
        output.monthInfo
            .receive(on: RunLoop.main)
            .sink { [weak self] monthInfo in
                guard let self else { return }
                
                self.didLoadFilledDates = true
                self.homeView.calendarView.filledDates = monthInfo.writtenDates
                self.homeView.calendarView.recoveredDates = self.mergedRecoveredDates(
                    with: monthInfo.recoveredDates
                )
                self.fetchAndShowDateInfo(for: self.homeView.calendarView.selectedDate ?? Date())
                self.showRecoveryModalIfNeeded()
            }
            .store(in: &viewModel.cancellables)
        
        viewModel.hasDraft
            .receive(on: RunLoop.main)
            .sink { [weak self] hasDraft in
                guard let self else { return }
                
                let date = self.pendingDraftDate ?? self.homeView.calendarView.selectedDate ?? Date()
                let topic = self.pendingDraftTopic
                let isRecoveryWriting = self.pendingDraftIsRecovery
                
                if hasDraft {
                    self.hideRecoveryTransitionOverlay()
                    self.showDraftDialog(
                        selectedDate: date,
                        topicData: topic,
                        isRecoveryWriting: isRecoveryWriting
                    )
                } else {
                    self.goToDiaryWritingView(
                        topicData: topic,
                        selectedDate: date,
                        shouldLoadDraft: false,
                        isRecoveryWriting: isRecoveryWriting
                    )
                }
            }
            .store(in: &viewModel.cancellables)
    }
    
    // MARK: - Action

    public override func addTarget() {
        
        // 주제 카드 눌렀을 때, 일기 작성화면으로 이동
        homeView.selectedInfo.cardTopicView.onTapWriteDiary = { [weak self] in
            guard let self else { return }
            guard let selectedDate = self.homeView.calendarView.selectedDate else { return }
            
            let topic = self.homeView.selectedInfo.topicData

            self.pendingDraftDate = selectedDate
            self.pendingDraftTopic = topic
            self.pendingDraftIsRecovery = self.isRecoveredDate(selectedDate)

            self.input.checkDraft.send(selectedDate)
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
        
        homeView.selectedInfo.onMenuAction = { [weak self] action, diaryId in
            guard let self else { return }
            
            switch action {
            case .publish:
                self.showDialog(for: .publish, diaryId: diaryId)
                
            case .unpublish:
                self.showDialog(for: .unpublish, diaryId: diaryId)
                
            case .delete:
                // TODO: 일기 삭제 기능 재오픈 시 삭제 다이얼로그 연결 복구
                // self.showDialog(for: .delete, diaryId: diaryId)
                break
            }
        }
        
        homeView.profileView.alarmButton.addTarget(
            self,
            action: #selector(alarmButtonTapped),
            for: .touchUpInside
        )
        
        let profileTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(profileImageTapped)
        )
        
        homeView.profileView.profileImageView.isUserInteractionEnabled = true
        homeView.profileView.profileImageView.addGestureRecognizer(profileTapGesture)
        
        homeView.selectedInfo.onTapRecovery = { [weak self] in
            guard let self else { return }
            guard let selectedDate = self.homeView.calendarView.selectedDate else { return }

            self.pendingRecoveryDate = selectedDate
            self.loadInterstitialAdAndPresent()
        }
    }
    
    // MARK: - Private Methods

    private func showOnboardingBottomSheet() -> Bool {
        guard UserDefaults.standard.bool(forKey: "showHomeOnboarding") else { return false }
        guard !hasShownOnboardingBottomSheet else { return false }
        
        hasShownOnboardingBottomSheet = true
        isShowingOnboardingBottomSheet = true

        let bottomSheet = OnboardingBottomSheet()
        onboardingBottomSheet = bottomSheet
        bottomSheet.onDismiss = { [weak self] in
            guard let self else { return }
            self.onboardingBottomSheet = nil
            self.isShowingOnboardingBottomSheet = false
            self.showNextHomeModal()
        }

        view.window?.addSubview(bottomSheet)
        bottomSheet.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        UserDefaults.standard.set(false, forKey: "showHomeOnboarding")
        return true
    }
    
    private func showNextHomeModal() {
        guard !isHomeModalVisible else { return }
        
        if !showUpdateNoticeModalIfNeeded() {
            showRecoveryModalIfNeeded()
        }
    }
    
    private func showUpdateNoticeModalIfNeeded() -> Bool {
        guard !isShowingOnboardingBottomSheet,
              let window = view.window,
              shouldShowUpdateNoticeModal() else { return false }
        
        markUpdateNoticeModalAsShown()
        updateNoticeModal.onDismiss = { [weak self] in
            self?.showRecoveryModalIfNeeded()
        }
        window.addSubview(updateNoticeModal)
        updateNoticeModal.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        updateNoticeModal.isHidden = false
        updateNoticeModal.configure(
            title: "이제 끊긴 기록을 되살릴 수 있어요!",
            subtitle: "미처 작성하지 못한 날짜를 누르고,\n광고 한 편 보고 끊긴 기록을 살려보세요.",
            image: UIImage(resource: .imgModalUpdateIos),
            buttonTitle: "확인했습니다",
            buttonText: nil,
            buttonAction: { [weak self] in
                self?.updateNoticeModal.dismissModal()
            }
        )
        updateNoticeModal.showAnimation()
        return true
    }
    
    private func shouldShowUpdateNoticeModal() -> Bool {
        !UserDefaults.standard.bool(forKey: didShowUpdateNoticeModalStorageKey)
    }
    
    private func markUpdateNoticeModalAsShown() {
        UserDefaults.standard.set(true, forKey: didShowUpdateNoticeModalStorageKey)
    }
    
    private func dateKey(_ date: Date) -> String {
        date.toFormattedString("yyyy-MM-dd")
    }
    
    private func recoveredDatesFromKeys() -> [Date] {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        formatter.dateFormat = "yyyy-MM-dd"
        return recoveredDateKeys.compactMap { formatter.date(from: $0) }
    }

    private func mergedRecoveredDates(with serverDates: [Date]) -> [Date] {
        let datesByKey = (serverDates + recoveredDatesFromKeys()).reduce(into: [String: Date]()) { result, date in
            result[dateKey(date)] = date
        }
        return Array(datesByKey.values)
    }

    private func loadRecoveredDatesFromStorage() {
        recoveredDateKeys = Set(UserDefaults.standard.stringArray(forKey: recoveredDateStorageKey) ?? [])
        homeView.calendarView.recoveredDates = recoveredDatesFromKeys()
    }

    private func isRecoveredDate(_ date: Date) -> Bool {
        recoveredDateKeys.contains(dateKey(date)) || homeView.calendarView.recoveredDates.contains {
            Calendar.current.isDate($0, inSameDayAs: date)
        }
    }

    private func saveRecoveredDate(_ date: Date) {
        recoveredDateKeys.insert(dateKey(date))
        UserDefaults.standard.set(Array(recoveredDateKeys), forKey: recoveredDateStorageKey)
        homeView.calendarView.recoveredDates = mergedRecoveredDates(
            with: homeView.calendarView.recoveredDates
        )
    }
    
    private func monthKey(_ date: Date) -> String {
        date.toFormattedString("yyyy-MM")
    }
    
    private func saveDismissedRecoveryModalMonth() {
        UserDefaults.standard.set(monthKey(Date()), forKey: dismissedRecoveryModalMonthStorageKey)
    }
    
    @discardableResult
    private func showRecoveryModalIfNeeded() -> Bool {
        let today = Date()
        let selectedDate = homeView.calendarView.selectedDate ?? today
        
        guard !isShowingOnboardingBottomSheet else { return false }
        guard !UserDefaults.standard.bool(forKey: "showHomeOnboarding") else { return false }
        guard canShowRecoveryModal(today: today, selectedDate: selectedDate) else { return false }
        guard let recoveryDate = mostRecentRecoveryViewDateInCurrentMonth() else { return false }
        
        guard !isUpdateNoticeModalVisible else { return false }
        guard !shouldShowUpdateNoticeModal() else { return false }
        guard !isHomeModalVisible else { return false }
        showRecoveryModal(for: recoveryDate)
        return true
    }
    
    private var isHomeModalVisible: Bool {
        isShowingOnboardingBottomSheet
        || (homeModal.superview != nil && !homeModal.isHidden)
        || isUpdateNoticeModalVisible
    }
    
    private var isUpdateNoticeModalVisible: Bool {
        updateNoticeModal.superview != nil && !updateNoticeModal.isHidden
    }
    
    private func canShowRecoveryModal(today: Date, selectedDate: Date) -> Bool {
        let calendar = Calendar.current
        let lastDay = calendar.range(of: .day, in: .month, for: today)?.count ?? 31
        let alreadyDismissed = UserDefaults.standard.string(forKey: dismissedRecoveryModalMonthStorageKey) == monthKey(today)
        
        return didLoadFilledDates
        && recoveryTickets > 0
        && calendar.isDate(selectedDate, equalTo: today, toGranularity: .month)
        && !alreadyDismissed
        && calendar.component(.day, from: today) >= lastDay - 7
    }
    
    private func mostRecentRecoveryViewDateInCurrentMonth() -> Date? {
        let calendar = Calendar.current
        let today = Date()
        let filledDateKeys = Set(homeView.calendarView.filledDates.map { dateKey($0) })
        let recoveredKeys = Set(homeView.calendarView.recoveredDates.map { dateKey($0) })
        var date = calendar.date(byAdding: .day, value: -2, to: today)
        
        while let candidate = date,
              calendar.isDate(candidate, equalTo: today, toGranularity: .month) {
            let key = dateKey(candidate)
            if !filledDateKeys.contains(key), !recoveredKeys.contains(key) {
                return candidate
            }
            
            date = calendar.date(byAdding: .day, value: -1, to: candidate)
        }
        
        return nil
    }
    
    private func showRecoveryModal(for missedDate: Date) {
        guard let window = view.window else { return }
        
        if homeModal.superview == nil {
            window.addSubview(homeModal)
            homeModal.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        homeModal.isHidden = false
        homeModal.configure(
            title: "연속 기록이 끊겼나요?",
            subtitle: "광고 한 번 보면 놓쳤던 날짜의 일기를\n다시 작성할 수 있어요.",
            image: UIImage(resource: .imgModalReturnRecordIos),
            buttonTitle: "기록 살리기",
            buttonText: "나중에 살리기",
            buttonAction: { [weak self] in
                guard let self else { return }
                
                self.saveDismissedRecoveryModalMonth()
                self.homeView.calendarView.select(date: missedDate)
                self.homeModal.dismissModal()
            },
            buttonTextAction: { [weak self] in
                guard let self else { return }
                
                self.saveDismissedRecoveryModalMonth()
                self.homeModal.dismissModal()
            }
        )
        homeModal.showAnimation()
    }

    private func removeFilledDate(_ date: Date) {
        homeView.calendarView.filledDates.removeAll {
            Calendar.current.isDate($0, inSameDayAs: date)
        }
    }

    private func fetchAndShowDateInfo(for date: Date) {
        currentDateRequestCancellable?.cancel()
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        let selectedDay = calendar.startOfDay(for: date)
        
        homeView.selectedInfo.setSelectedDate(date)
        homeView.selectedInfo.currentDiaryId = nil

        if isRecoveredDate(date) {
            fetchRecoveredTopicIfAvailable(for: date)
            currentDateRequestCancellable?.store(in: &viewModel!.cancellables)
            return
        }
        
        let isDiaryDate = homeView.calendarView.filledDates.contains {
            calendar.isDate($0, inSameDayAs: date)
        }
        
        if isDiaryDate {
            currentDateRequestCancellable = viewModel?.fetchDiary(for: date)
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { [weak self] completion in
                    if case .failure = completion {
                        self?.removeFilledDate(date)
                        if self?.isRecoveredDate(date) == true {
                            self?.fetchRecoveredTopicIfAvailable(for: date)
                        } else {
                            self?.homeView.selectedInfo.updateView(
                                for: date,
                                diaryId: nil,
                                isPublished: nil,
                                remainingTime: 0,
                                topicData: nil,
                                diaryData: nil,
                                imageURL: nil
                            )
                        }
                    }
                }, receiveValue: { [weak self] diary in
                    guard let self else { return }
                    
                    if let diary {
                        self.homeView.selectedInfo.updateView(
                            for: date,
                            diaryId: diary.diaryId,
                            isPublished: diary.isPublished,
                            remainingTime: 0,
                            topicData: nil,
                            diaryData: diary.originalText,
                            imageURL: diary.imageUrl
                        )
                    } else {
                        if selectedDay > today {
                            self.homeView.selectedInfo.updateView(
                                for: date,
                                diaryId: nil,
                                isPublished: nil,
                                remainingTime: 0,
                                topicData: nil,
                                diaryData: nil,
                                imageURL: nil
                            )
                        } else {
                            self.fetchTopicIfNeeded(
                                for: date,
                                today: today,
                                yesterday: yesterday
                            )
                        }
                    }
                })
        } else {
            if isRecoveredDate(date) {
                fetchRecoveredTopicIfAvailable(for: date)
            } else if selectedDay > today {
                homeView.selectedInfo.updateView(
                    for: date,
                    diaryId: nil,
                    isPublished: nil,
                    remainingTime: 0,
                    topicData: nil,
                    diaryData: nil,
                    imageURL: nil
                )
            } else {
                fetchTopicIfNeeded(
                    for: date,
                    today: today,
                    yesterday: yesterday
                )
            }
        }
        
        currentDateRequestCancellable?.store(in: &viewModel!.cancellables)
    }
    
    func showToast(message: String) {
        let toast = ToastMessage()
        view.addSubview(toast)
        toast.configure(type: .basic, message: message)
    }
    
    private func showDraftDialog(
        selectedDate: Date,
        topicData: (String, String)?,
        isRecoveryWriting: Bool
    ) {
        guard let window = view.window else { return }

        window.addSubview(dialog)
        dialog.snp.remakeConstraints {
            $0.edges.equalToSuperview()
        }

        dialog.configure(
            style: .normal,
            title: "작성 중인 일기가 있어요.",
            content: "임시저장한 일기를 이어 쓰시겠어요?",
            leftButtonTitle: "새로 쓰기",
            rightButtonTitle: "이어 쓰기",
            leftAction: { [weak self] in
                guard let self else { return }
                
                self.dialog.dismiss()

                self.goToDiaryWritingView(
                    topicData: topicData,
                    selectedDate: selectedDate,
                    shouldLoadDraft: false,
                    isRecoveryWriting: isRecoveryWriting
                )
            },
            rightAction: { [weak self] in
                guard let self else { return }
                
                self.dialog.dismiss()

                self.goToDiaryWritingView(
                    topicData: topicData,
                    selectedDate: selectedDate,
                    shouldLoadDraft: true,
                    isRecoveryWriting: isRecoveryWriting
                )
            }
        )

        dialog.showAnimation()
    }

    // MARK: - Topic 조회 로직 분리

    private func fetchRecoveredTopicIfAvailable(for date: Date) {
        currentDateRequestCancellable = viewModel?.fetchTopic(for: date)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure = completion {
                    self?.homeView.selectedInfo.updateView(
                        for: date,
                        diaryId: nil,
                        isPublished: nil,
                        remainingTime: 0,
                        topicData: nil,
                        diaryData: nil,
                        imageURL: nil
                    )
                }
            }, receiveValue: { [weak self] topic in
                guard let self else { return }
                guard let topic else {
                    self.homeView.selectedInfo.updateView(
                        for: date,
                        diaryId: nil,
                        isPublished: nil,
                        remainingTime: 0,
                        topicData: nil,
                        diaryData: nil,
                        imageURL: nil
                    )
                    return
                }

                let isRecovered = self.isRecoveredDate(date)
                let topicData = isRecovered ? (topic.topicKor, topic.topicEn) : nil
                self.homeView.selectedInfo.updateView(
                    for: date,
                    diaryId: nil,
                    isPublished: nil,
                    remainingTime: 0,
                    topicData: topicData,
                    diaryData: nil,
                    imageURL: nil,
                    isRecovered: isRecovered
                )
            })

        currentDateRequestCancellable?.store(in: &viewModel!.cancellables)
    }
    
    private func fetchTopicIfNeeded(for date: Date, today: Date, yesterday: Date) {
        let calendar = Calendar.current
        let selectedDay = calendar.startOfDay(for: date)
        if isRecoveredDate(date) {
            fetchRecoveredTopicIfAvailable(for: date)
            return
        }

        guard calendar.isDate(selectedDay, inSameDayAs: today)
                || calendar.isDate(selectedDay, inSameDayAs: yesterday) else {
            homeView.selectedInfo.updateView(
                for: date,
                diaryId: nil,
                isPublished: nil,
                remainingTime: 0,
                topicData: nil,
                diaryData: nil,
                imageURL: nil
            )
            return
        }
        
        currentDateRequestCancellable = viewModel?.fetchTopic(for: date)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure = completion {
                    self?.homeView.selectedInfo.updateView(
                        for: date,
                        diaryId: nil,
                        isPublished: nil,
                        remainingTime: 0,
                        topicData: nil,
                        diaryData: nil,
                        imageURL: nil
                    )
                }
            }, receiveValue: { [weak self] topic in
                guard let self else { return }
                
                let remaining = max(0, topic?.remainingTime ?? 0)
                let topicData = remaining > 0 ? topic.map { ($0.topicKor, $0.topicEn) } : nil
                
                self.homeView.selectedInfo.updateView(
                    for: date,
                    diaryId: nil,
                    isPublished: nil,
                    remainingTime: remaining,
                    topicData: topicData,
                    diaryData: nil,
                    imageURL: nil
                )
            })
        
        currentDateRequestCancellable?.store(in: &viewModel!.cancellables)
    }
    
    private func showOverlay() {
        let overlay = UIControl()
        overlay.backgroundColor = .clear
        overlay.addTarget(self, action: #selector(dismissMenu), for: .touchUpInside)
        
        view.addSubview(overlay)
        overlay.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        overlayView = overlay

        if homeView.selectedInfo.menu.superview != nil {
            homeView.selectedInfo.menu.removeFromSuperview()
        }
        
        view.addSubview(homeView.selectedInfo.menu)

        homeView.selectedInfo.menu.snp.remakeConstraints {
            $0.top.equalTo(homeView.selectedInfo.moreImageView.snp.bottom).offset(4)
            $0.trailing.equalTo(homeView.selectedInfo.moreImageView.snp.trailing)
            // TODO: 일기 삭제 기능 재오픈 시 오버레이 메뉴 높이 원복 검토
            $0.height.equalTo(48)
            $0.width.equalTo(182)
        }

        homeView.selectedInfo.menu.isHidden = false
        view.bringSubviewToFront(homeView.selectedInfo.menu)
    }
    
    private func showDialog(for action: MenuAction, diaryId: Int) {
        guard let window = view.window else { return }

        window.addSubview(dialog)
        dialog.snp.remakeConstraints {
            $0.edges.equalToSuperview()
        }
        
        switch action {
        case .publish:
            dialog.configure(
                style: .normal,
                title: "영어 일기를 게시하시겠어요?",
                content: "공유된 일기는 모든 유저에게 게시되며,\n피드에서 확인하실 수 있어요.",
                leftButtonTitle: "아니요",
                rightButtonTitle: "게시하기",
                leftAction: { [weak dialog] in
                    dialog?.dismiss()
                },
                rightAction: { [weak self] in
                    guard let self else { return }
                    
                    self.viewModel?.publishDiary(diaryId: diaryId)
                        .receive(on: RunLoop.main)
                        .sink(receiveCompletion: { completion in
                            if case .failure = completion {
                                print("🚨 게시하기 API 호출 실패")
                            }
                        }, receiveValue: { [weak self] _ in
                            guard let self else { return }
                            
                            self.homeView.selectedInfo.updateDiaryState(isPublished: true)
                            self.homeView.selectedInfo.updateMenuState(isPublished: true)
                            self.dialog.dismiss()
                            
                            let toast = ToastMessage()
                            self.view.addSubview(toast)
                            toast.configure(
                                type: .withButton,
                                message: "일기가 게시되었어요!",
                                actionTitle: "보러가기"
                            )
                            
                            toast.action = { [weak self] in
                                guard let self else { return }
                                customTabBarController?.selectedIndex = 2
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
                leftAction: { [weak dialog] in
                    dialog?.dismiss()
                },
                rightAction: { [weak self] in
                    guard let self else { return }
                    
                    self.viewModel?.unpublishDiary(diaryId: diaryId)
                        .receive(on: RunLoop.main)
                        .sink(receiveCompletion: { completion in
                            if case .failure = completion {
                                print("🚨 비공개하기 API 호출 실패")
                            }
                        }, receiveValue: { [weak self] _ in
                            guard let self else { return }
                            
                            self.homeView.selectedInfo.updateDiaryState(isPublished: false)
                            self.homeView.selectedInfo.updateMenuState(isPublished: false)
                            self.dialog.dismiss()
                            
                            let toast = ToastMessage()
                            self.view.addSubview(toast)
                            toast.configure(type: .basic, message: "일기가 비공개 되었어요.")
                        })
                        .store(in: &self.viewModel!.cancellables)
                }
            )
            
        case .delete:
            dialog.configure(
                style: .normal,
                title: "영어 일기를 삭제하시겠어요?",
                content: "작성한 일기를 삭제한 날짜에는\n다시 일기를 작성할 수 없어요.",
                leftButtonTitle: "아니요",
                rightButtonTitle: "삭제하기",
                leftAction: { [weak dialog] in
                    dialog?.dismiss()
                },
                rightAction: { [weak self] in
                    guard let self else { return }
                    
                    self.viewModel?.deleteDiary(diaryId: diaryId)
                        .receive(on: RunLoop.main)
                        .sink(receiveCompletion: { completion in
                            if case .failure = completion {
                                print("🚨 삭제하기 API 호출 실패")
                            }
                        }, receiveValue: { [weak self] _ in
                            guard let self else { return }
                            
                            self.refreshUserInfo(shouldShowRecoveryModal: false)
                            
                            let selectedDate = self.homeView.calendarView.selectedDate ?? Date()
                            let calendar = Calendar.current
                            let year = calendar.component(.year, from: selectedDate)
                            let month = calendar.component(.month, from: selectedDate)
                            
                            self.input.monthChange.send((year, month))
                            
                            self.homeView.selectedInfo.updateView(
                                for: selectedDate,
                                diaryId: nil,
                                isPublished: nil,
                                remainingTime: 0,
                                topicData: nil,
                                diaryData: nil,
                                imageURL: nil
                            )
                            
                            let toast = ToastMessage()
                            self.view.addSubview(toast)
                            toast.configure(type: .basic, message: "삭제가 완료되었어요.")
                            
                            self.dialog.dismiss()
                        })
                        .store(in: &self.viewModel!.cancellables)
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
    
    @objc private func profileImageTapped() {
        goToMyFeedProefileView()
    }
    
    // MARK: - Navigation
    
    private func goToDiaryWritingView(
        topicData: (String, String)? = nil,
        selectedDate: Date? = nil,
        shouldLoadDraft: Bool = false,
        isRecoveryWriting: Bool = false
    ) {
        let diaryWritingVC = diContainer.makeDiaryWritingViewController(
            topicData: topicData,
            selectedDate: selectedDate ?? Date(),
            shouldLoadDraft: shouldLoadDraft,
            isRecoveryWriting: isRecoveryWriting
        )
        
        diaryWritingVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(diaryWritingVC, animated: true)

        guard recoveryTransitionOverlay != nil else { return }
        guard let transitionCoordinator = navigationController?.transitionCoordinator else {
            hideRecoveryTransitionOverlay()
            return
        }
        transitionCoordinator.animate(alongsideTransition: nil) { [weak self] _ in
            self?.hideRecoveryTransitionOverlay()
        }
    }
    
    private func goToDiaryDetailView(diaryId: Int) {
        let detailVC = diContainer.makeDiaryDetailViewController(diaryId: diaryId)
        detailVC.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    private func goToMyFeedProefileView() {
        let myFeedProfileVC = diContainer.makeMyFeedProfileViewController()
        myFeedProfileVC.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(myFeedProfileVC, animated: true)
    }

    private func checkAndRequestLocalPushPermission() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            
            let shouldRegister = await localPushPermissionService.checkAndRequestPermission()
            guard shouldRegister else { return }
            
            self.viewModel?.registerInitialLocalPushes()
        }
    }
    
    private func fetchRecoveredTopicAndWrite(for date: Date) {
        viewModel?.fetchTopic(for: date)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure = completion {
                    self?.hideRecoveryTransitionOverlay()
                }
            }, receiveValue: { [weak self] topic in
                guard let self else { return }
                guard let topic else {
                    self.hideRecoveryTransitionOverlay()
                    return
                }

                let topicData = (topic.topicKor, topic.topicEn)
                self.homeView.selectedInfo.updateView(
                    for: date,
                    diaryId: nil,
                    isPublished: nil,
                    remainingTime: 0,
                    topicData: topicData,
                    diaryData: nil,
                    imageURL: nil,
                    isRecovered: true
                )

                self.pendingDraftDate = date
                self.pendingDraftTopic = topicData
                self.pendingDraftIsRecovery = true
                self.input.checkDraft.send(date)
            })
            .store(in: &viewModel!.cancellables)
    }

    private func showRecoveryTransitionOverlay() {
        guard recoveryTransitionOverlay == nil else { return }

        let overlay = UIView()
        overlay.backgroundColor = .white

        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .gray500
        indicator.startAnimating()

        overlay.addSubview(indicator)
        view.addSubview(overlay)

        overlay.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        indicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        recoveryTransitionOverlay = overlay
        view.layoutIfNeeded()
    }

    private func hideRecoveryTransitionOverlay() {
        recoveryTransitionOverlay?.removeFromSuperview()
        recoveryTransitionOverlay = nil
    }

    private func resetRecoveryAdState() {
        pendingRecoveryDate = nil
        rewardedInterstitial = nil
        didEarnRecoveryReward = false
        hideRecoveryTransitionOverlay()
    }

    private func canPresentRecoveryAd() -> Bool {
        view.window != nil && presentedViewController == nil && UIApplication.shared.topViewController() == self
    }

    @MainActor
    private func showRecoveryAdFailureDialog() {
        DialogManager.shared.show(message: "광고를 불러오지 못했어요.\n잠시 후 다시 시도해주세요.")
    }
    
    private func loadInterstitialAdAndPresent() {
        let adUnitID = Bundle.main.infoDictionary?["AD_RECOVERY_UNIT_ID"] as? String ?? ""

        RewardedInterstitialAd.load(with: adUnitID, request: Request()) { [weak self] ad, error in
            nonisolated(unsafe) let loadedAd = ad
            let errorDescription = error.map { String(describing: $0) }

            Task { @MainActor [weak self] in
                guard let self else { return }

                if let errorDescription {
                    print("🚨 보상형 전면 광고 로드 실패: \(errorDescription)")
                    self.resetRecoveryAdState()
                    self.showRecoveryAdFailureDialog()
                    return
                }

                guard let loadedAd else {
                    self.resetRecoveryAdState()
                    self.showRecoveryAdFailureDialog()
                    return
                }

                guard self.canPresentRecoveryAd() else {
                    self.resetRecoveryAdState()
                    self.showRecoveryAdFailureDialog()
                    return
                }

                self.didEarnRecoveryReward = false
                self.rewardedInterstitial = loadedAd
                self.rewardedInterstitial?.fullScreenContentDelegate = self
                self.rewardedInterstitial?.present(from: self) { [weak self] in
                    print("✅ 전면 광고 시청 완료")
                    self?.didEarnRecoveryReward = true
                    self?.showRecoveryTransitionOverlay()
                }
            }
        }
    }

    // MARK: - Recall
    
    private func updateUserInfo(
        _ userInfo: HomeUserInfoViewData,
        shouldShowRecoveryModal: Bool = true
        ) {
        UserDefaults.standard.set(
            userInfo.nickname.trimmingCharacters(in: .whitespacesAndNewlines),
            forKey: "currentUser.nickname"
        )
        recoveryTickets = userInfo.recoveryTickets
        homeView.selectedInfo.canShowRecoveryView = userInfo.recoveryTickets > 0
        homeView.profileView.updateView(
            nickname: userInfo.nickname,
            profileImageURL: userInfo.profileImageURL,
            totalDiaries: userInfo.totalDiaries,
            streak: userInfo.streak,
            recoveryTickets: userInfo.recoveryTickets,
            newAlarm: userInfo.newAlarm
        )
        if let selectedDate = homeView.calendarView.selectedDate {
            fetchAndShowDateInfo(for: selectedDate)
        }
        if shouldShowRecoveryModal {
            showRecoveryModalIfNeeded()
        }
    }
    
    private func refreshUserInfo(shouldShowRecoveryModal: Bool = true) {
        viewModel?.fetchUserInfo()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] userInfo in
                self?.updateUserInfo(userInfo, shouldShowRecoveryModal: shouldShowRecoveryModal)
            })
            .store(in: &viewModel!.cancellables)
    }
}

// MARK: - FullScreenContentDelegate

extension HomeViewController: FullScreenContentDelegate {
    public func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        guard let recoveryDate = pendingRecoveryDate else {
            resetRecoveryAdState()
            return
        }

        pendingRecoveryDate = nil
        rewardedInterstitial = nil

        guard didEarnRecoveryReward else {
            resetRecoveryAdState()
            return
        }
        didEarnRecoveryReward = false

        viewModel?.postHomeAdWatch(for: recoveryDate)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("🚨 전면 광고 호출 실패: \(error)")
                    self.hideRecoveryTransitionOverlay()
                }
            }, receiveValue: { [weak self] in
                self?.saveRecoveredDate(recoveryDate)
                self?.fetchRecoveredTopicAndWrite(for: recoveryDate)
            })
            .store(in: &viewModel!.cancellables)
    }

    public func ad(
        _ ad: FullScreenPresentingAd,
        didFailToPresentFullScreenContentWithError error: Error
    ) {
        print("🚨 전면 광고 표시 실패: \(error)")
        resetRecoveryAdState()
        showRecoveryAdFailureDialog()
    }
}
