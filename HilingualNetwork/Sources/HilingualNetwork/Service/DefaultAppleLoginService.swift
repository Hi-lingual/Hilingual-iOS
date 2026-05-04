//
//  DefaultAppleLoginService.swift
//  HilingualNetwork
//
//  Created by 성현주 on 7/8/25.
//

import AuthenticationServices
import Combine

public protocol AppleLoginService {
    func performAppleLogin() -> AnyPublisher<(String, String), Error>
}

public final class DefaultAppleLoginService: NSObject, AppleLoginService {
    private var promise: ((Result<(String, String), Error>) -> Void)?

    public func performAppleLogin() -> AnyPublisher<(String, String), Error> {
        return Future<(String, String), Error> { [weak self] promise in
            guard let self else { return }

            self.promise = promise

            let provider = ASAuthorizationAppleIDProvider()
            let request = provider.createRequest()
            request.requestedScopes = [.email, .fullName]

            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }
        .eraseToAnyPublisher()
    }
}

extension DefaultAppleLoginService: ASAuthorizationControllerDelegate {
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let tokenData = credential.identityToken,
              let token = String(data: tokenData, encoding: .utf8) else {
            promise?(.failure(AppleLoginError.invalidToken))
            return
        }

        let userId = credential.user
        promise?(.success((token, userId)))
    }

    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        promise?(.failure(error))
    }
}

extension DefaultAppleLoginService: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first { $0.isKeyWindow } ?? UIWindow()
    }
}
