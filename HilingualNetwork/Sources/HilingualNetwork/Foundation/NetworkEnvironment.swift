//
//  NetworkEnvironment.swift
//  HilingualNetwork
//
//  Created by 성현주 on 7/9/25.
//

import Foundation

public enum NetworkEnvironment {
    private static var _shared: BaseURLProvider?
    
    public static func configure(_ provider: BaseURLProvider) {
        _shared = provider
    }
    
    public static var shared: BaseURLProvider {
        guard let provider = _shared else {
            fatalError("NetworkEnvironment.configure() must be called before use")
        }
        return provider
    }
}
