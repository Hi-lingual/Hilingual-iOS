//
//  NotificationDetailViewModel.swift
//  HilingualPresentation
//
//  Created by 성현주 on 8/26/25.
//

import Foundation
import Combine
import HilingualDomain

public final class NotificationDetailViewModel: BaseViewModel {

    // MARK: - Input / Output

    public struct Input {
        let appear: AnyPublisher<Void, Never>
    }

    public struct Output {
        let detail: AnyPublisher<NotificationDetailModel, Never>
    }

    // MARK: - Private

    private let useCase: NotificationUseCase
    private let notiId: Int
    private let detailSubject = PassthroughSubject<NotificationDetailModel, Never>()

    // MARK: - Init

    public init(notiId: Int, useCase: NotificationUseCase) {
        self.notiId = notiId
        self.useCase = useCase
    }

    // MARK: - Transform

    public func transform(input: Input) -> Output {
        input.appear
            .sink { [weak self] in self?.fetchDetail() }
            .store(in: &cancellables)

        return Output(detail: detailSubject.eraseToAnyPublisher())
    }

    private func fetchDetail() {
        useCase.fetchNotificationDetail(notiId: notiId)
            .map {
                NotificationDetailModel(
                    title: $0.title,
                    date: DisplayDateFormatter.notificationDate(
                        utcString: $0.createdAtUtc,
                        fallback: $0.createdAt
                    ),
                    content: $0.content
                )
            }
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] model in
                      self?.detailSubject.send(model)
                  })
            .store(in: &cancellables)
    }
}
