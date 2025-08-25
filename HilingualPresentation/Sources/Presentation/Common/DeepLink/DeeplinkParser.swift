//
//  DeeplinkParser.swift
//  HilingualPresentation
//
//  Created by 성현주 on 8/26/25.
//


import Foundation

public struct DeeplinkParser {

    public static func parse(url: URL) -> DeeplinkDestination? {
        guard url.scheme?.lowercased() == "hilingual",
              url.host?.lowercased() == "notification" else {
            return nil
        }

        let path = url.path.lowercased()

        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = components?.queryItems ?? []

        func queryValue(for key: String) -> String? {
            return queryItems.first { $0.name.lowercased() == key.lowercased() }?.value
        }

        switch path {
        case "/diarydetail":
            if let idString = queryValue(for: "diaryid"), let id = Int(idString) {
                return .diaryDetail(diaryId: id)
            }

        case "/feedprofile":
            if let idString = queryValue(for: "userid"), let id = Int(idString) {
                return .userProfile(userId: id)
            }

        default:
            break
        }

        return nil
    }

}
