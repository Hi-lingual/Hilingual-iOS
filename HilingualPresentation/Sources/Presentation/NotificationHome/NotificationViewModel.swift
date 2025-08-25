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

    // MARK: - Published

    @Published public private(set) var generalNotifications: [NotificationModel] = []
    @Published public private(set) var noticeNotifications: [NotificationModel] = []

    // MARK: - Private

    private let useCase: NotificationUseCase

    // MARK: - Init

    public init(useCase: NotificationUseCase) {
        self.useCase = useCase
    }

    // MARK: - Input / Output

    public struct Input {
        let fetchGeneral: PassthroughSubject<Void, Never> = .init()
        let fetchNotice: PassthroughSubject<Void, Never> = .init()
    }

    public struct Output {
        let generalNotifications: Published<[NotificationModel]>.Publisher
        let noticeNotifications: Published<[NotificationModel]>.Publisher
    }

    public lazy var input = Input()
    public lazy var output = Output(
        generalNotifications: $generalNotifications,
        noticeNotifications: $noticeNotifications
    )

    // MARK: - Bind

    public func bind() {
        input.fetchGeneral
            .sink { [weak self] _ in self?.fetchGeneralNotifications() }
            .store(in: &cancellables)

        input.fetchNotice
            .sink { [weak self] _ in self?.fetchNoticeNotifications() }
            .store(in: &cancellables)
    }

    // MARK: - Fetch

    private func fetchGeneralNotifications() {
        useCase.fetchFeedNotifications()
            .map { entities in
                entities.map {
                    NotificationModel(
                        id: $0.id,
                        type: .feed, title: $0.title,
                        isRead: $0.isRead,
                        publishedAt: $0.publishedAt, deeplink: $0.deeplink
                    )
                }
            }
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] items in
                      self?.generalNotifications = items
                  })
            .store(in: &cancellables)
    }

    private func fetchNoticeNotifications() {
        useCase.fetchNoticeNotifications()
            .map { entities in
                entities.map {
                    NotificationModel(
                        id: $0.id,
                        type: .notice, title: $0.title,
                        isRead: $0.isRead,
                        publishedAt: $0.publishedAt, deeplink: nil
                    )
                }
            }
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] items in
                      self?.noticeNotifications = items
                  })
            .store(in: &cancellables)
    }
}
