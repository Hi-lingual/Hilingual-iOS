//
//  BaseURLProvider.swift
//  HilingualNetwork
//
//  Created by 성현주 on 7/9/25.
//

import Foundation

public protocol BaseURLProvider {
    var baseURL: URL { get }
    //TODO: 토큰 변경
    var token: String { get }
}
