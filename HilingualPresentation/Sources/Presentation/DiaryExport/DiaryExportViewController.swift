//
//  DiaryExportViewController.swift
//  HilingualPresentation
//
//  Created by 진소은 on 10/16/26.
//

import UIKit
import Photos
import SnapKit

public final class DiaryExportViewController: BaseUIViewController<DiaryExportViewModel> {

    // MARK: - Properties

    private let diaryId: Int
    private let data: DiaryViewData
    private let topic: String

    // MARK: - UI Components

    private let exportView = DiaryExportView()

    private let shareModal: Modal = {
        let modal = Modal()
        modal.isHidden = true
        return modal
    }()

    // MARK: - Init

    public init(
        viewModel: DiaryExportViewModel,
        diContainer: ViewControllerFactory,
        diaryId: Int,
        data: DiaryViewData,
        topic: String
    ) {
        self.diaryId = diaryId
        self.data = data
        self.topic = topic
        super.init(viewModel: viewModel, diContainer: diContainer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        attachShareModal()
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        shareModal.removeFromSuperview()
    }

    private func attachShareModal() {
        guard let container = navigationController?.view, shareModal.superview !== container else {
            return
        }
        container.addSubview(shareModal)
        container.bringSubviewToFront(shareModal)
        shareModal.snp.remakeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    // MARK: - Custom Method

    public override func setUI() {
        view.backgroundColor = .gray100
        view.addSubview(exportView)

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance

        exportView.setTopic(topic)
        exportView.setDate(DisplayDateFormatter.diaryExportDate(apiDate: data.apiDate))
        exportView.configure(
            image: data.imageURL,
            originalText: data.originalText,
            highlightText: data.rewriteText,
            diffRanges: data.diffRanges,
            isHighlightingEnabled: true
        )

        configureShareModal()
    }

    private func configureShareModal() {
        shareModal.configure(
            title: nil,
            items: [
                ("이미지 공유하기",
                 UIImage(named: "ic_export_24_ios", in: .module, with: nil),
                 { [weak self] in self?.handleShare() }),
                ("이미지 저장하기",
                 UIImage(resource: .icDownload24Ios),
                 { [weak self] in self?.handleSave() })
            ]
        )
    }

    private func handleShare() {
        let image = exportView.renderCardSnapshot()
        shareModal.dismissModal()

        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = view
            popover.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        activityVC.completionWithItemsHandler = { [weak self] activityType, completed, _, error in
            guard completed, error == nil, activityType == .saveToCameraRoll else { return }
            Task { @MainActor in
                self?.showToast(message: "일기가 이미지로 저장되었어요.")
            }
        }
        present(activityVC, animated: true)
    }

    private func handleSave() {
        let image = exportView.renderCardSnapshot()
        shareModal.dismissModal()

        Task { [weak self] in
            guard let self else { return }
            let status = await self.requestPhotoAuthorization()
            guard status == .authorized || status == .limited else { return }
            self.writeImageToAlbum(image)
        }
    }

    private func requestPhotoAuthorization() async -> PHAuthorizationStatus {
        let current = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        if current == .notDetermined {
            return await PHPhotoLibrary.requestAuthorization(for: .addOnly)
        }
        return current
    }

    private func writeImageToAlbum(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(
            image,
            self,
            #selector(saveImageCompleted(_:didFinishSavingWithError:contextInfo:)),
            nil
        )
    }

    @objc private func saveImageCompleted(
        _ image: UIImage,
        didFinishSavingWithError error: Error?,
        contextInfo: UnsafeRawPointer
    ) {
        guard error == nil else { return }
        showToast(message: "일기가 이미지로 저장되었어요.")
    }

    private func showToast(message: String) {
        let toast = ToastMessage()
        view.addSubview(toast)
        toast.configure(type: .basic, message: message)
    }

    public override func setLayout() {
        exportView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    // MARK: - Navigation

    public override func navigationType() -> NavigationType? {
        .closeTitleMenu(title: "일기 카드 미리보기", rightIconName: "ic_export_24_gray500_ios")
    }

    @objc public override func menuButtonTapped() {
        shareModal.isHidden = false
        shareModal.showAnimation()
    }
}
