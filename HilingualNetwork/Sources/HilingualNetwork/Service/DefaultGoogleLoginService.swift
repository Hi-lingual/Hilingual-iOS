//
//  DefaultGoogleLoginService.swift
//  HilingualNetwork
//
//  Created by 성현주 on 11/15/26.
//

import Combine
import UIKit

import GoogleSignIn

public protocol GoogleLoginService {
    func performGoogleLogin() -> AnyPublisher<String, Error>
}

public final class DefaultGoogleLoginService: GoogleLoginService {

    public init() {}

    public static func handle(_ url: URL) -> Bool {
        GIDSignIn.sharedInstance.handle(url)
    }

    public func performGoogleLogin() -> AnyPublisher<String, Error> {
        return Future<String, Error> { promise in
            DispatchQueue.main.async {
                guard let presenter = Self.topViewController() else {
                    promise(.failure(GoogleLoginError.presenterNotFound))
                    return
                }

                GIDSignIn.sharedInstance.signIn(withPresenting: presenter) { result, error in
                    if let error {
                        promise(.failure(error))
                        return
                    }

                    guard let idToken = result?.user.idToken?.tokenString else {
                        promise(.failure(GoogleLoginError.invalidToken))
                        return
                    }

                    promise(.success(idToken))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    private static func topViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first { $0.isKeyWindow }

        var top = keyWindow?.rootViewController
        while let presented = top?.presentedViewController {
            top = presented
        }
        return top
    }
}
