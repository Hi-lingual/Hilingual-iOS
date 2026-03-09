//
//  NetworkEnvironment.swift
//  HilingualNetwork
//
//  Created by 성현주 on 7/9/25.
//

import Foundation

public enum NetworkEnvironment {
    //TODO: - 강제 언래핑 제거
    nonisolated(unsafe) public static var shared: BaseURLProvider!
}
