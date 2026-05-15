//
//  DeeplinkManager.swift
//  HilingualPresentation
//
//  Created by 성현주 on 8/26/25.
//


import UIKit

public final class DeeplinkManager {

    @MainActor public static let shared = DeeplinkManager()
    @MainActor public var onPendingDestinationSet: ((DeeplinkDestination) -> Void)?
    
    @MainActor public var pendingDestination: DeeplinkDestination? {
        didSet {
            if let destination = pendingDestination {
                onPendingDestinationSet?(destination)
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

        case .home:
            nav.popToRootViewController(animated: true)
        }
    }
}
