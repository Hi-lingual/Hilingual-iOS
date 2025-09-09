//
//  NotificationViewModel.swift
//  HilingualPresentation
//
//  Created by 성현주 on 8/26/25.
//

import Foundation
import Combine
import HilingualDomain

public final class NotificationViewModel: BaseViewModel {

    // MARK: - Input

    public struct Input {
        let fetchGeneral: AnyPublisher<Void, Never>
        let fetchNotice: AnyPublisher<Void, Never>
        let markAsRead: AnyPublisher<Int, Never>
    }

    public struct Output {
        let generalNotifications: AnyPublisher<[NotificationModel], Never>
        let noticeNotifications: AnyPublisher<[NotificationModel], Never>
    }

    // MARK: - Private Subjects

    private let generalSubject = CurrentValueSubject<[NotificationModel], Never>([])
    private let noticeSubject = CurrentValueSubject<[NotificationModel], Never>([])

    private let useCase: NotificationUseCase

    // MARK: - Init

    public init(useCase: NotificationUseCase) {
        self.useCase = useCase
    }

    // MARK: - Transform

    public func transform(input: Input) -> Output {

        input.markAsRead
            .flatMap { [weak self] id -> AnyPublisher<Void, Never> in
                guard let self else { return Empty().eraseToAnyPublisher() }

                return self.useCase.markNotificationAsRead(notiId: id)
                    .handleEvents(receiveOutput: {
                    }, receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            print("알림 읽음 처리 실패: \(error)")
                        }
                    })
                    .catch { _ in Empty() }
                    .eraseToAnyPublisher()
            }
            .sink { _ in }
            .store(in: &cancellables)

        input.fetchGeneral
            .flatMap { [weak self] _ -> AnyPublisher<[NotificationModel], Never> in
                guard let self else { return Just([]).eraseToAnyPublisher() }

                return self.useCase.fetchFeedNotifications()
                    .map { entities in
                        entities.map {
                            NotificationModel(
                                id: $0.id,
                                type: .feed,
                                title: $0.title,
                                isRead: $0.isRead,
                                publishedAt: $0.publishedAt,
                                targetId: $0.targetId
                            )
                        }
                    }
                    .catch { _ in Just([]) }
                    .handleEvents(receiveOutput: { [weak self] models in
                        self?.generalSubject.send(models)
                    })
                    .eraseToAnyPublisher()
            }
            .sink { _ in }
            .store(in: &cancellables)

        input.fetchNotice
            .flatMap { [weak self] _ -> AnyPublisher<[NotificationModel], Never> in
                guard let self else { return Just([]).eraseToAnyPublisher() }

                return self.useCase.fetchNoticeNotifications()
                    .map { entities in
                        entities.map {
                            NotificationModel(
                                id: $0.id,
                                type: .notice,
                                title: $0.title,
                                isRead: $0.isRead,
                                publishedAt: $0.publishedAt,
                                targetId: nil
                            )
                        }
                    }
                    .catch { _ in Just([]) }
                    .handleEvents(receiveOutput: { [weak self] models in
                        self?.noticeSubject.send(models)
                    })
                    .eraseToAnyPublisher()
            }
            .sink { _ in }
            .store(in: &cancellables)

        return Output(
            generalNotifications: generalSubject.eraseToAnyPublisher(),
            noticeNotifications: noticeSubject.eraseToAnyPublisher()
        )
    }
}
