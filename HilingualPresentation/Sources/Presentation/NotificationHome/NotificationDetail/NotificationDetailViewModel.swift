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
            .flatMap { [weak self] _ -> AnyPublisher<NotificationDetailModel, Never> in
                guard let self = self else { return Empty().eraseToAnyPublisher() }

                return self.useCase.fetchNotificationDetail(notiId: self.notiId)
                    .map { entity in
                        NotificationDetailModel(
                            title: entity.title,
                            date: entity.createdAt,
                            content: entity.content
                        )
                    }
                    .catch { _ in Empty() }
                    .eraseToAnyPublisher()
            }
            .sink { [weak self] model in
                self?.detailSubject.send(model)
            }
            .store(in: &cancellables)

        return Output(detail: detailSubject.eraseToAnyPublisher())
    }
}
