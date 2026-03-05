//
//  AdMobManager.swift
//  HilingualPresentation
//
//  Created by 성현주 on 3/1/26.
//

import Foundation
import GoogleMobileAds

enum AdMobManager {

    private static let startOnce: Void = {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }()

    static func startIfNeeded() {
        _ = startOnce
    }
}
