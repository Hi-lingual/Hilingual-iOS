//
//  SharedDiaryViewController.swift
//  HilingualPresentation
//
//  Created by 진소은 on 8/21/25.
//

import Foundation
import SafariServices
import UIKit

import Combine

public final class SharedDiaryViewController: BaseUIViewController<SharedDiaryViewModel> {
    
    // MARK: - Properties
    
    private var isMine: Bool = true
    private let diaryId: Int
    
    private let viewDidLoadSubject = PassthroughSubject<Void, Never>()

    // MARK: - UI Components
    
    private let dialog = Dialog()
    private let modal: Modal = {
        let modal = Modal()
        modal.isHidden = true
        return modal
    }()
    
    private let sharedDiaryView = SharedDiaryView()
    private lazy var diaryDetailViewController: DiaryDetailViewController = {
        let vc = diContainer.makeDiaryDetailViewController(diaryId: diaryId)
        vc.showsActionButton = false
        return vc
    }()
    private let bottomSafeAreaBackgroundView = UIView()
    
    // MARK: - Init
    
    public init(viewModel: SharedDiaryViewModel, diContainer: ViewControllerFactory, diaryId: Int) {
        self.diaryId = diaryId
        super.init(viewModel: viewModel, diContainer: diContainer)
    }
    
    // MARK: - LifeCycle

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        addChild(diaryDetailViewController)
        diaryDetailViewController.didMove(toParent: self)
        
        sharedDiaryView.onProfileAction = { [weak self] in
            guard let self else { return }
            let vc = diContainer.makeMyFeedProfileViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }

        sharedDiaryView.onLikeAction = { [weak self] isLiked in
            guard let self else { return }
            self.likeToggleSubject.send((self.diaryId, isLiked))
        }
        
        viewDidLoadSubject.send(())
    }
    
    // MARK: SetUI
    
    public override func setUI() {
        view.addSubviews(bottomSafeAreaBackgroundView, sharedDiaryView, diaryDetailViewController.view, modal, dialog)
        
        modal.isHidden = true
        dialog.isHidden = true
        bottomSafeAreaBackgroundView.backgroundColor = .gray100
        
        view.bringSubviewToFront(modal)
        view.bringSubviewToFront(bottomSafeAreaBackgroundView)
    }
    
    public override func setLayout() {
        sharedDiaryView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(62)
        }
        
        bottomSafeAreaBackgroundView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        diaryDetailViewController.view.snp.makeConstraints {
            $0.top.equalTo(sharedDiaryView.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        modal.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        dialog.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Binding
    
    private let likeToggleSubject = PassthroughSubject<(Int, Bool), Never>()
    private let publishToggleSubject = PassthroughSubject<(Int, Bool), Never>()
    
    public override func bind(viewModel: SharedDiaryViewModel) {
        super.bind(viewModel: viewModel)
        
        let input = makeInput()
        let output = viewModel.transform(input: input)
        
        bindOutput(output)
    }
    
    private func makeInput() -> SharedDiaryViewModel.Input {
        return SharedDiaryViewModel.Input(
            viewDidLoad: viewDidLoadSubject.eraseToAnyPublisher(),
            likeTapped: likeToggleSubject.eraseToAnyPublisher(),
            publishTapped: publishToggleSubject.eraseToAnyPublisher(),
            )
    }
    
    private func bindOutput(_ output: SharedDiaryViewModel.Output) {
        output.fetchDiaryResult
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case let .failure(error) = completion {
                        self?.showErrorDialog(message: error.localizedDescription)
                    }
                },
                receiveValue: { [weak self] entity in
                    guard let self else { return }
                    
                    // 바로 View에 바인딩
                    self.sharedDiaryView.configure(
                        profileImgURL: entity.profile.profileImg,
                        nickname: entity.profile.nickname,
                        streak: entity.profile.streak,
                        sharedDateMinutes: entity.diary.sharedDate,
                        isLiked: entity.diary.isLiked,
                        likeCount: entity.diary.likeCount
                    )
                    
                    self.isMine = entity.isMine
                }

            )
            .store(in: &cancellables)
    }

    // MARK: - Public Methods
    
    public override func navigationType() -> NavigationType? {
        return .backTitleMenu(title: "")
    }
    
    @objc public override func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    public override func menuButtonTapped() {
        showModal()
    }
    
    
    // MARK: - Actions
    // TODO: - 차단하기 modal 연결
    
    @objc private func showModal() {
            let items: [(String, UIImage?, () -> Void)]

            if isMine {
                    items = [
                        ("비공개하기", UIImage(resource: .icHide24Ios), { [weak self] in
                            guard let self else { return }
                            // TODO: 서버에 비공개 전환 API 호출
                            self.modal.isHidden = true
                            showPrivateDialog()
                        })
                    ]
            } else {
                items = [
                    ("계정 차단하기", UIImage(resource: .icBlockGray24Ios), { [weak self] in
                        self?.modal.isHidden = true
                        // TODO: 서버 차단 API 호출
                    }),
                    ("게시글 신고하기", UIImage(resource: .icReport24Ios), { [weak self] in
                        self?.modal.isHidden = true
                        self?.showReportDialog()
                    })
                ]
            }

            modal.configure(
                title: nil,
                items: items
            )
            modal.isHidden = false
            DispatchQueue.main.async { [weak self] in
                self?.modal.showAnimation()
            }
        }
    
    @objc private func showPrivateDialog() {
        dialog.configure(
            title: "영어 일기를 비공개 하시겠어요?",
            content: "비공개로 전환 시,\n해당 일기의 피드 활동 내역은 모두 사라져요.",
            leftButtonTitle: "아니요",
            rightButtonTitle: "비공개하기",
            leftAction: { [weak self] in
                self?.dialog.dismiss()
            },
            rightAction: { [weak self] in
                guard let self else { return }
                self.dialog.dismiss()
                
                self.publishToggleSubject.send((self.diaryId, false))
                
                if let nav = self.navigationController {
                    nav.popViewController(animated: true)
                    if let previousVC = nav.viewControllers.last {
                        let toast = ToastMessage()
                        previousVC.view.addSubview(toast)
                        toast.configure(type: .basic, message: "일기가 비공개 되었어요.")
                    }
                }
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
                self?.navigationController?.popViewController(animated: true)
            }
        )
        
        dialog.showAnimation()
    }
    
    private func showReportDialog() {
        dialog.configure(
            style: .normal,
            image: UIImage(resource: .imgErrorIos),
            title: "게시글을 신고하시겠어요?",
            content: "신고된 게시글은 확인 후\n서비스의 운영원칙에 따라 처리돼요.",
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
}
