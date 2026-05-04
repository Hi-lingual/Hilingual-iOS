//
//  AppBaseURLProvider.swift
//  Hilingual
//
//  Created by 성현주 on 7/9/25.
//

import Foundation
import HilingualNetwork

struct AppBaseURLProvider: BaseURLProvider {
    var baseURL: URL {
        guard let urlString = Bundle.main.infoDictionary?["BASE_URL"] as? String,
              let url = URL(string: urlString) else {
            fatalError("BASE_URL이 Info.plist에 정의 안됨 ㅋ")
        }
        return url
    }
    var token: String {
        guard let token = Bundle.main.infoDictionary?["TOKEN"] as? String else {
            fatalError("TOKEN이 Info.plist에 정의 안됨 ㅋ")
        }
        return token
    }
}
