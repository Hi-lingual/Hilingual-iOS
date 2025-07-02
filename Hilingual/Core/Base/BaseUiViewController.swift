//
//  BaseUiViewController.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import UIKit
import Combine

class BaseUIViewController<VM: BaseViewBindable>: UIViewController {

    // MARK: - Properties

    public var cancellables = Set<AnyCancellable>()
    public var viewModel: VM?

    // MARK: - Init

    public init(viewModel: VM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind(viewModel: viewModel)
        HilingualLog.debug("[VC LifeCycle] \(Self.self) init")
    }

    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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

    //MARK: - Bind Method

    open func bind(viewModel: VM) {
        self.viewModel = viewModel
    }

    // MARK: - Action Method

    func addTarget() {}

    // MARK: - delegate Method

    func setDelegate() {}

    // MARK: - Deinit

    deinit {
        HilingualLog.debug("[VC LifeCycle] \(Self.self) deinit")
    }
}
