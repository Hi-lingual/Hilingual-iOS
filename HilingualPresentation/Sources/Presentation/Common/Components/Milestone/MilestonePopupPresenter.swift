//
//  MilestonePopupPresenter.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 10/18/26.
//

import UIKit
import Photos
import SnapKit
import HilingualCore

@MainActor
enum MilestonePopupPresenter {

    private static weak var currentPopup: MilestonePopupView?

    static func presentIfNeeded(from vc: UIViewController) {
        guard currentPopup == nil,
              let window = vc.view.window,
              MilestoneStore.shared.hasPending,
              let count = MilestoneStore.shared.consume() else { return }

        let popup = MilestonePopupView()
        popup.configure(count: count)
        popup.onShareTapped = { [weak vc, weak popup] image in
            guard let vc else { return }
            share(image, from: vc, popup: popup)
        }
        popup.onSaveTapped = { [weak popup] image in
            save(image, popup: popup)
        }
        popup.show(on: window)
        currentPopup = popup
    }

    // MARK: - Share

    private static func share(_ image: UIImage, from vc: UIViewController, popup: MilestonePopupView?) {
        AmplitudeManager.shared.send(.clickMilestoneImageShare)
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = vc.view
        activityVC.popoverPresentationController?.sourceRect = CGRect(
            x: vc.view.bounds.midX, y: vc.view.bounds.midY, width: 0, height: 0
        )
        activityVC.completionWithItemsHandler = { [weak popup] activityType, completed, _, error in
            guard completed, error == nil, activityType == .saveToCameraRoll else { return }
            Task { @MainActor in
                showToast("카드가 이미지로 저장되었어요.", on: popup)
            }
        }
        (vc.presentedViewController ?? vc).present(activityVC, animated: true)
    }

    // MARK: - Save

    private static func save(_ image: UIImage, popup: MilestonePopupView?) {
        AmplitudeManager.shared.send(.clickMilestoneImageDownload)
        Task { @MainActor [weak popup] in
            let status = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
            guard status == .authorized else { return }

            do {
                try await saveToPhotoLibrary(image)
                showToast("카드가 이미지로 저장되었어요.", on: popup)
            } catch {
                showToast("이미지 저장에 실패했어요.", on: popup)
            }
        }
    }

    nonisolated private static func saveToPhotoLibrary(_ image: UIImage) async throws {
        try await PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }
    }

    private static func showToast(_ message: String, on popup: MilestonePopupView?) {
        guard let popup else { return }
        let toast = ToastMessage()
        popup.addSubview(toast)
        toast.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(58)
        }
        toast.configure(type: .basic, message: message)
    }
}
