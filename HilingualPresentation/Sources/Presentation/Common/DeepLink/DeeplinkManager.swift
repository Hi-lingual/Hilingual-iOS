//
//  DeeplinkManager.swift
//  HilingualPresentation
//
//  Created by 성현주 on 8/26/25.
//

import UIKit
import HilingualCore

public final class DeeplinkManager {

    @MainActor public static let shared = DeeplinkManager()
    @MainActor public var onPendingDestinationSet: ((DeeplinkDestination) -> Bool)?
    
    @MainActor public var pendingDestination: DeeplinkDestination? {
        didSet {
            guard let destination = pendingDestination else { return }

            if onPendingDestinationSet?(destination) == true {
                pendingDestination = nil
            }
        }
    }
    private init() {}

    @MainActor
    public func handle(_ destination: DeeplinkDestination, from nav: UINavigationController, di: ViewControllerFactory) {
        switch destination {
        case .diaryDetail(let id):
            let vc = di.makeSharedDiaryViewController(diaryId: id)
            nav.pushViewController(vc, animated: true)

        case .userProfile(let userId):
            let vc = di.makeUserFeedProfileViewController(userId: Int64(userId))
            nav.pushViewController(vc, animated: true)
            
        case .home, .reminderStreak, .reminderWinback, .reminderCustom:
            nav.popToRootViewController(animated: true)
        }
    }
}

extension DeeplinkManager {
    @discardableResult
    @MainActor
    public func handlePushTap(userInfo: [AnyHashable: Any]) -> DeeplinkDestination? {
        guard let link = userInfo["link"] as? String,
              let url = URL(string: link),
              let destination = DeeplinkParser.parse(
                  url: url,
                  notificationType: userInfo["notification_type"] as? String
              ) else {
            return nil
        }

        if let analytics = destination.pushNotificationAnalytics {
            AmplitudeManager.shared.send(
                .clickPushNotification(notificationType: analytics.type, page: analytics.page)
            )
        }

        pendingDestination = destination
        return destination
    }
}
