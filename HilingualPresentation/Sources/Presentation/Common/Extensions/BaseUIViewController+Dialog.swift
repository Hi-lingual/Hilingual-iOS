//
//  UIViewController+Dialog.swift
//  HilingualPresentation
//
//  Created by 성현주 on 9/11/25.
//

import UIKit
import SnapKit

extension UIViewController {

    /// 서버 오류 다이얼로그
    func showServerErrorDialog(message: String) {
        guard let topVC = UIApplication.shared.topViewController(),
              topVC == self else { return }

        let dialog = Dialog(frame: view.bounds)

        dialog.configure(
            style: .error,
            title: message,
            rightButtonTitle: "확인",
            rightAction: { [weak dialog, weak self] in
                dialog?.dismiss()
                if let nav = self?.navigationController {
                    nav.popViewController(animated: true)
                } else {
                    self?.dismiss(animated: true)
                }
            }
        )

        view.addSubview(dialog)
        dialog.snp.makeConstraints { $0.edges.equalToSuperview() }
        dialog.showAnimation()
    }
}

extension UIApplication {
    func topViewController(base: UIViewController? =
        UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return tab.selectedViewController.flatMap { topViewController(base: $0) }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
