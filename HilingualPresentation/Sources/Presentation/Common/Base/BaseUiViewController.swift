//
//  BaseUIViewController.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import UIKit
import Combine

public class BaseUIViewController<VM: BaseViewBindable>: UIViewController {

    // MARK: - Properties

    public var cancellables = Set<AnyCancellable>()
    public var viewModel: VM?
    public let diContainer: any DIContainer  

    // MARK: - Init

    public init(viewModel: VM, diContainer: any DIContainer) {
        self.viewModel = viewModel
        self.diContainer = diContainer
        super.init(nibName: nil, bundle: nil)
        bind(viewModel: viewModel)
        setupNavigationBar()
        HilingualLog.debug("[VC LifeCycle] \(Self.self) init")
    }

    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setUI()
        setLayout()
        addTarget()
        setDelegate()
    }

    // MARK: - Custom Method

    open func setUI() {}
    open func setLayout() {}
    open func addTarget() {}
    open func setDelegate() {}

    //MARK: - Bind Method

    open func bind(viewModel: VM) {
        self.viewModel = viewModel
    }

    // MARK: - Navigation Method

    open func navigationType() -> NavigationType? {
        return nil
    }

    @objc open func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc open func menuButtonTapped() {
    }

    // MARK: - Deinit

    deinit {
        HilingualLog.debug("[VC LifeCycle] \(Self.self) deinit")
    }
}
