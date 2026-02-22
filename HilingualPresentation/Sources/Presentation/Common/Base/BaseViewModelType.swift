//
//  ViewModelType.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Foundation
import Combine

// MARK: - Input/Output

public protocol BaseViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}

// MARK: - LifeCycle

public protocol BaseViewBindable {
    var viewDidLoad: PassthroughSubject<Void, Never> { get }
    var viewWillAppear: PassthroughSubject<Void, Never> { get }
    var viewDidAppear: PassthroughSubject<Void, Never> { get }
    var viewWillDisappear: PassthroughSubject<Void, Never> { get }
    var viewDidDisappear: PassthroughSubject<Void, Never> { get }
    var cancellables: Set<AnyCancellable> { get set }
}

// MARK: - BaseViewModel

open class BaseViewModel: BaseViewBindable {
    public let viewDidLoad = PassthroughSubject<Void, Never>()
    public let viewWillAppear = PassthroughSubject<Void, Never>()
    public let viewDidAppear = PassthroughSubject<Void, Never>()
    public let viewWillDisappear = PassthroughSubject<Void, Never>()
    public let viewDidDisappear = PassthroughSubject<Void, Never>()

    public let finishForPop = PassthroughSubject<Void, Never>()
    public let finishForDismiss = PassthroughSubject<Void, Never>()

    public var cancellables = Set<AnyCancellable>()

    public init() {
        HilingualLog.debug("[VM LifeCycle] \(Self.self) init")
    }

    deinit {
        HilingualLog.debug("[VM LifeCycle] \(Self.self) deinit")
    }
}
