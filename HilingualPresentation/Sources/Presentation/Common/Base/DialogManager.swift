//
//  DialogManager.swift
//  HilingualPresentation
//
//  Created by 성현주 on 9/16/25.
//

import UIKit
import SnapKit
import Network

final class DialogManager {
    @MainActor static let shared = DialogManager()

    private var isDialogPresented = false
    private weak var currentDialog: Dialog?

    private init() {}

    /// 일반 에러 다이얼로그
    @MainActor
    func show(message: String,
              style: Dialog.DialogStyle = .error,
              confirmTitle: String = "확인",
              popOnConfirm: Bool = false,
              confirmAction: (() -> Void)? = nil) {
        guard !isDialogPresented else { return }

        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
            .first else { return }

        let dialog = Dialog(frame: window.bounds)

        dialog.configure(
            style: style,
            title: message,
            rightButtonTitle: confirmTitle,
            rightAction: { [weak self, weak dialog] in
                dialog?.dismiss()
                self?.isDialogPresented = false
                self?.currentDialog = nil

                if let confirmAction {
                    confirmAction()
                } else if popOnConfirm, let topVC = UIApplication.shared.topViewController() {
                    if let nav = topVC.navigationController {
                        nav.popViewController(animated: true)
                    } else {
                        topVC.dismiss(animated: true)
                    }
                }
            }
        )

        window.addSubview(dialog)
        dialog.snp.makeConstraints { $0.edges.equalToSuperview() }
        dialog.showAnimation()

        currentDialog = dialog
        isDialogPresented = true
    }

    /// 네트워크 에러 다이얼로그 (기존 Dialog 재사용)
    @MainActor
    func showNetworkError(using monitor: NWPathMonitor) {
        guard !isDialogPresented else { return }

        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
            .first else { return }

        let dialog = Dialog(frame: window.bounds)

        dialog.configure(
            style: .error,
            title: "네트워크 연결을 확인해주세요",
            rightButtonTitle: "확인",
            rightAction: { [weak self, weak dialog] in
                guard let self else { return }
                if monitor.currentPath.status == .satisfied {
                    dialog?.dismiss()
                    self.isDialogPresented = false
                    self.currentDialog = nil
                } else {
                    return
                }
            }
        )

        window.addSubview(dialog)
        dialog.snp.makeConstraints { $0.edges.equalToSuperview() }
        dialog.showAnimation()

        currentDialog = dialog
        isDialogPresented = true
    }

    @MainActor
    func dismissIfNeeded() {
        currentDialog?.dismiss()
        currentDialog = nil
        isDialogPresented = false
    }
}
