//
//  DiaryDetailViewController.swift
//  HilingualPresentation
//
//  Created by 진소은 on 7/8/25.
//

import Foundation
import UIKit
import Combine
import SafariServices
import HilingualCore

public final class DiaryDetailViewController: BaseUIViewController<DiaryDetailViewModel> {

    // MARK: - Properties

    let diaryId: Int
    var date: String = ""
    private var isPublished: Bool = true
    private let deleteTappedSubject = PassthroughSubject<Void, Never>()
    private let publishTappedSubject = PassthroughSubject<Void, Never>()
    private let unpublishTappedSubject = PassthroughSubject<Void, Never>()

    private let diaryDetailView = DiaryDetailView()
    private var isHighlightingEnabled: Bool = true
    private let dialog = Dialog()
    private let detailImage = DetailImageView(image: UIImage(resource: .imgLoadFailLargeIos))

    private let spacer = UIView()
    private let bottomSafeAreaBackgroundView = UIView()

    let modal: Modal = {
        let modal = Modal()
        modal.isHidden = true
        return modal
    }()

    private let button: CTAButton = {
        let button = CTAButton(style: .TextButton("피드에 게시하기"), autoBackground: true)
        button.isEnabled = true
        return button
    }()

    private lazy var feedbackViewController = diContainer.makeFeedbackViewController(diaryId: diaryId)
    private lazy var recommendedExpressionViewController = diContainer.makeRecommendedExpressionViewController(diaryId: diaryId)

    private var segmentedControl: SegmentedControl!

    public var showsActionButton: Bool = true

    // Amplitude Tracking Properties
    private var entryId: String = ""
    private var entrySource: String = "unknown"
    private var backSource: String = "ui_button"
    private var toggleClickCount: Int = 0

    // MARK: - Init

    public init(
        viewModel: DiaryDetailViewModel,
        diContainer: ViewControllerFactory,
        diaryId: Int,
        entrySource: String = "unknown"
    ) {
        self.diaryId = diaryId
        self.entryId = String(diaryId)
        self.entrySource = entrySource
        super.init(viewModel: viewModel, diContainer: diContainer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        feedbackViewController.showsAdBanner = !showsActionButton
        recommendedExpressionViewController.showsAdBanner = !showsActionButton

        AmplitudeManager.shared.send(.pageviewFeedback)

        hideKeyboardWhenTappedAround()
        updateButtonTitle()

        segmentedControl = SegmentedControl(
            viewControllers: [feedbackViewController, recommendedExpressionViewController],
            titles: ["문법·철자", "추천표현"],
            parentViewController: self
        )

        diaryDetailView.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(diaryDetailView.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

        feedbackViewController.onDateLoaded = { [weak self] date in
            self?.recommendedExpressionViewController.setDate(date)
        }

        feedbackViewController.publishedInfoLoaded = { [weak self] isPublished in
            self?.isPublished = isPublished
            self?.updateButtonTitle()
        }

        feedbackViewController.onToggleChanged = { [weak self] isEnabled in
            guard let self = self else { return }
            self.toggleClickCount += 1

            AmplitudeManager.shared.send(
                .clickFeedbackToggle(
                    clickCount: self.toggleClickCount,
                    isEnabled: isEnabled
                )
            )
        }

        recommendedExpressionViewController.onBookmarkToggle = { [weak self] phraseId, isBookmarked in
            guard let self = self else { return }

            AmplitudeManager.shared.send(
                .bookmarkAction(
                    entryId: self.entryId,
                    entrySource: .from(self.entrySource),
                    action: isBookmarked ? .add : .remove
                )
            )
        }

        if showsActionButton {
            button.addTarget(self, action: #selector(postButtonTapped), for: .touchUpInside)
        }
    }

    public override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        updateButtonTitle()
    }

    // MARK: - Custom Method

    public override func setUI() {
        if showsActionButton {
            view.addSubviews(diaryDetailView, modal, dialog, spacer, bottomSafeAreaBackgroundView, button)
            bottomSafeAreaBackgroundView.backgroundColor = .white
        } else {
            view.addSubviews(diaryDetailView, modal, dialog, bottomSafeAreaBackgroundView)
            bottomSafeAreaBackgroundView.backgroundColor = .gray100
        }
        view.bringSubviewToFront(modal)
        view.bringSubviewToFront(dialog)
    }

    public override func setLayout() {
        diaryDetailView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }

        modal.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        dialog.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        if showsActionButton {
            bottomSafeAreaBackgroundView.snp.makeConstraints {
                $0.leading.trailing.bottom.equalToSuperview()
                    $0.height.equalTo(120)
            }

            button.snp.makeConstraints {
                $0.horizontalEdges.equalToSuperview().inset(16)
                $0.bottom.equalToSuperview().inset(50)
            }

            diaryDetailView.snp.remakeConstraints {
                $0.horizontalEdges.top.equalToSuperview()
                $0.bottom.equalTo(spacer.snp.top)
            }

            spacer.snp.makeConstraints {
                $0.horizontalEdges.equalToSuperview()
                $0.bottom.equalToSuperview()
                $0.height.equalTo(110)
            }
        }
    }

    public override func bind(viewModel: DiaryDetailViewModel) {
        super.bind(viewModel: viewModel)

        let input = DiaryDetailViewModel.Input(
            deleteTapped: deleteTappedSubject.eraseToAnyPublisher(),
            publishTapped: publishTappedSubject.eraseToAnyPublisher(),
            unpublishTapped: unpublishTappedSubject.eraseToAnyPublisher()
        )

        let output = viewModel.transform(input: input)

        output.deleteResult
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self?.navigationController?.popToRootViewController(animated: true)

                    if let homeVC = self?.navigationController?.viewControllers.first {
                        let toast = ToastMessage()
                        homeVC.view.addSubview(toast)
                        toast.configure(type: .basic, message: "삭제가 완료되었어요.")
                    }
                }
            }
            .store(in: &cancellables)

        output.publishResult
            .receive(on: RunLoop.main)
            .sink { [weak self] isPublished in
                guard let self = self else { return }
                self.isPublished = isPublished
                self.updateButtonTitle()

                let toast = ToastMessage()
                self.view.addSubview(toast)

                if isPublished {
                    toast.configure(type: .withButton, message: "일기가 게시되었어요!")
                    toast.action = { [weak self] in
                        AmplitudeManager.shared.send(
                            .toastAction(
                                action: .ctaClick,
                                toastId: .diaryPostSuccess,
                                entryId: self?.entryId ?? ""
                            )
                        )
                        self?.tabBarController?.selectedIndex = 2
                        self?.navigationController?.popToRootViewController(animated: false)
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
                        AmplitudeManager.shared.send(
                            .toastAction(
                                action: .autoDismiss,
                                toastId: .diaryPostSuccess,
                                entryId: self?.entryId ?? ""
                            )
                        )
                    }
                } else {
                    toast.configure(type: .basic, message: "일기가 비공개 되었어요.")
                }
            }
            .store(in: &cancellables)

        output.errorMessage
            .receive(on: RunLoop.main)
            .sink { [weak self] message in
                self?.showErrorDialog(message: message)
            }
            .store(in: &cancellables)
    }


    public override func navigationType() -> NavigationType? {
        return .backTitleMenu(title: "일기장")
    }

    @objc public override func backButtonTapped() {
        AmplitudeManager.shared.send(
            .clickBackFeedback(
                entryId: entryId,
                backSource: .uiButton
            )
        )
        navigationController?.popToRootViewController(animated: true)
    }

    @objc private func postButtonTapped() {
        if isPublished {
            showPrivateDialog()
        } else {
            showPostDialog()
        }
    }

    // MARK: - Actions

    public override func menuButtonTapped() {
        showModal()
    }

    private func updateButtonTitle() {
        let title = isPublished ? "비공개하기" : "피드에 게시하기"
        button.setTitle(title, for: .normal)
    }

    @objc private func showModal() {
        modal.configure(
            title: nil,
            items: [
                ("삭제하기", UIImage(resource: .icDelete24Ios), { [weak self] in
                    self?.modal.isHidden = true
                    self?.showDeleteDialog()
                }),
                ("AI 피드백 신고하기", UIImage(resource: .icReport24Ios), { [weak self] in
                    self?.modal.isHidden = true
                    self?.showReportDialog()
                })
            ]
        )

        modal.applyStyle(to: 0, titleColor: .alertRed)
        modal.isHidden = false

        DispatchQueue.main.async { [weak self] in
            self?.modal.showAnimation()
        }
    }

    @objc private func showDeleteDialog() {
        dialog.configure(
            title: "일기를 삭제하시겠어요?",
            content: "작성한 일기를 삭제한 날짜에는\n다시 일기를 작성할 수 없어요.",
            leftButtonTitle: "아니요",
            rightButtonTitle: "삭제하기",
            leftAction: { [weak self] in
                self?.dialog.dismiss()
            },
            rightAction: { [weak self] in
                self?.dialog.dismiss()
                self?.deleteTappedSubject.send(())
            }
        )
        dialog.showAnimation()
    }

    @objc private func showReportDialog() {
        dialog.configure(
            title: "AI 피드백을 신고하시겠어요?",
            content: "신고된 AI 피드백은 확인 후\n서비스의 운영원칙에 따라 처리돼요.",
            leftButtonTitle: "아니요",
            rightButtonTitle: "신고하기",
            leftAction: { [weak self] in
                self?.dialog.dismiss()
            },
            rightAction: { [weak self] in
                self?.dialog.dismiss()
                guard let url = URL(string: "https://hilingual.notion.site/230829677ebf801c965be24b0ef444e9") else { return }
                let safariVC = SFSafariViewController(url: url)
                self?.present(safariVC, animated: true)
            }
        )
        dialog.showAnimation()
    }

    @objc private func showPostDialog() {
        dialog.configure(
            title: "영어 일기를 게시하시겠어요?",
            content: "공유된 일기는 모든 유저에게 게시되며,\n피드에서 확인하실 수 있어요.",
            leftButtonTitle: "아니요",
            rightButtonTitle: "게시하기",
            leftAction: { [weak self] in
                self?.dialog.dismiss()
            },
            rightAction: { [weak self] in
                guard let self = self else { return }
                self.dialog.dismiss()

                AmplitudeManager.shared.send(.submittedPostDiary(entryId: self.entryId))

                self.publishTappedSubject.send(())
            }
        )
        dialog.showAnimation()
    }

    @objc private func showPrivateDialog() {
        dialog.configure(
            title: "영어 일기를 비공개 하시겠어요?",
            content: "비공개로 전환 시, 해당 일기의\n피드 활동 내역은 모두 사라져요.",
            leftButtonTitle: "아니요",
            rightButtonTitle: "비공개하기",
            leftAction: { [weak self] in
                self?.dialog.dismiss()
            },
            rightAction: { [weak self] in
                guard let self else { return }
                self.dialog.dismiss()
                self.unpublishTappedSubject.send(())
            }
        )
        dialog.showAnimation()
    }

    private func showErrorDialog(message: String) {
        dialog.configure(
            style: .error,
            image: UIImage(resource: .imgErrorIos),
            title: "앗! 일시적인 오류가 발생했어요.",
            rightButtonTitle: "확인",
            rightAction: { [weak self] in
                self?.dialog.dismiss()
            }
        )
        dialog.showAnimation()
    }
}
