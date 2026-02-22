//
//  UIControl+.swift
//  Hilingual
//
//  Created by 성현주 on 7/3/25.
//

import UIKit
import Combine

extension UIControl {

    // 기본 control event Publisher
    func publisher(for event: UIControl.Event) -> AnyPublisher<Void, Never> {
        UIControlPublisher(control: self, event: event)
            .eraseToAnyPublisher()
    }
}

// MARK: - Custom Publisher

private struct UIControlPublisher: @preconcurrency Publisher {
    typealias Output = Void
    typealias Failure = Never

    let control: UIControl
    let event: UIControl.Event

    @MainActor func receive<S: Subscriber>(subscriber: S) where S.Input == Output, S.Failure == Failure {
        let subscription = UIControlSubscription(subscriber: subscriber, control: control, event: event)
        subscriber.receive(subscription: subscription)
    }
}

// MARK: - Custom Subscription

@MainActor
private final class UIControlSubscription<S: Subscriber>: @preconcurrency Subscription where S.Input == Void {
    private var subscriber: S?
    private weak var control: UIControl?
    private let event: UIControl.Event

    init(subscriber: S, control: UIControl, event: UIControl.Event) {
        self.subscriber = subscriber
        self.control = control
        self.event = event
        control.addTarget(self, action: #selector(eventHandler), for: event)
    }

    func request(_ demand: Subscribers.Demand) {
        // 수동으로 이벤트 발생시켜서 처리하므로 별도 수요 없음
    }

    func cancel() {
        control?.removeTarget(self, action: #selector(eventHandler), for: event)
        subscriber = nil
    }

    @objc private func eventHandler() {
        _ = subscriber?.receive(())
    }
}
