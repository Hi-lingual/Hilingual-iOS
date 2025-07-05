//
//  BaseUIViewController.swift
//  HilingualPresentation
//
//  Created by 성현주 on 7/6/25.
//

import UIKit
import Combine

// MARK: - NavigationType Extension

public extension BaseUIViewController {

    enum NavigationType {
        case titleOnly(String)
        case backTitle(String)
        case backTitleMenu(String)
        case backOnly
    }

    // MARK: - Setup

    func setupNavigationBar() {
        guard let type = navigationType() else { return }

        switch type {
        case .titleOnly(let title):
            navigationItem.titleView = makeTitleLabel(title)
            navigationItem.leftBarButtonItem = nil
            navigationItem.rightBarButtonItem = nil

        case .backTitle(let title):
            navigationItem.titleView = makeTitleLabel(title)
            navigationItem.leftBarButtonItem = makeBarButton(
                imageName: "chevron.left",
                action: #selector(backButtonTapped)
            )
            navigationItem.rightBarButtonItem = nil

        case .backTitleMenu(let title):
            navigationItem.titleView = makeTitleLabel(title)
            navigationItem.leftBarButtonItem = makeBarButton(
                imageName: "chevron.left",
                action: #selector(backButtonTapped)
            )
            navigationItem.rightBarButtonItem = makeBarButton(
                imageName: "ellipsis",
                action: #selector(menuButtonTapped)
            )

        case .backOnly:
            navigationItem.titleView = nil
            navigationItem.leftBarButtonItem = makeBarButton(
                imageName: "chevron.left",
                action: #selector(backButtonTapped)
            )
            navigationItem.rightBarButtonItem = nil
        }
    }

    // MARK: - Title Label

    private func makeTitleLabel(_ title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }

    // MARK: - Button

    private func makeBarButton(imageName: String, action: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: imageName)?.withRenderingMode(.alwaysTemplate)

        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: action, for: .touchUpInside)

        button.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        button.imageView?.contentMode = .scaleAspectFit

        return UIBarButtonItem(customView: button)
    }
}
