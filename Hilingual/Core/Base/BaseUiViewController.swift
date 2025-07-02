//
//  BaseUiViewController.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import UIKit

class BaseUIViewController: UIViewController {

    // MARK: - Properties

    // MARK: - UI Components

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setUI()
        setLayout()
        addTarget()
        setDelegate()

    }

    // MARK: - Custom Method

    func setUI() {}

    func setLayout() {}

    // MARK: - Action Method

    func addTarget() {}

    // MARK: - delegate Method

    func setDelegate() {}
}
