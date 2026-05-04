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
                    .handleEvents(receiveCompletion: { completion in
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
                        entities.compactMap { self.toModel(from: $0) }
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
                        entities.compactMap { self.toModel(from: $0) }
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

    // MARK: - Private Helper

    private func toModel(from entity: NotificationEntity) -> NotificationModel? {
        let type: NotificationType

        switch entity.type {
        case .general(let rawType):
            type = .feed(rawType)

        case .notice(let rawType):
            type = .notice(rawType)
        }

        return NotificationModel(
            id: entity.id,
            type: type,
            title: entity.title,
            isRead: entity.isRead,
            publishedAt: DisplayDateFormatter.notificationDate(
                utcString: entity.publishedAtUtc,
                fallback: entity.publishedAt
            ),
            targetId: entity.targetId
        )
    }
}
