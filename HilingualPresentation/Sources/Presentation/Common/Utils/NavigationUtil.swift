//
//  changeRootVC.swift
//  HilingualPresentation
//
//  Created by 성현주 on 7/8/25.
//

import Foundation
import UIKit

@MainActor
func changeRootVC(_ viewController: UIViewController, animated: Bool = true) {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let window = windowScene.windows.first else {
        return
    }

    if animated {
        UIView.transition(
            with: window,
            duration: 0.4,
            options: [.transitionCrossDissolve],
            animations: {
                window.rootViewController = viewController
            }
        )
    } else {
        window.rootViewController = viewController
    }

    window.makeKeyAndVisible()
}


