//
//  BaseService.swift
//  Hilingual
//
//  Created by 성현주 on 7/3/25.
//

import Foundation
import Combine
import Moya
import Alamofire
import HilingualCore

public class BaseService<API: TargetType> {

    // MARK: - Transport Error Mapping

    static func transportError(from error: Error) -> NetworkError {
        guard let code = urlErrorCode(in: error) else { return .unknown }
        return code == NSURLErrorTimedOut ? .timeout : .networkFail
    }

    private static func urlErrorCode(in error: Error) -> Int? {
        if let urlError = error as? URLError {
            return urlError.code.rawValue
        }
        if let afError = error as? AFError, let underlying = afError.underlyingError {
            return urlErrorCode(in: underlying)
        }
        let nsError = error as NSError
        if nsError.domain == NSURLErrorDomain {
            return nsError.code
        }
        if let underlying = nsError.userInfo[NSUnderlyingErrorKey] as? NSError {
            return urlErrorCode(in: underlying)
        }
        return nil
    }

    // MARK: - Properties

    private let provider: MoyaProvider<API>

    // MARK: - Init

    public init(provider: MoyaProvider<API> = NetworkProvider.make()) {
        self.provider = provider
    }

    // MARK: - Request (Decodable Response)
    
    public func request<T: Decodable>(_ target: API, as type: T.Type) -> AnyPublisher<T, HilingualError> {
        #if DEBUG
        if let forced = NetworkDebug.forcedError(for: target.path) {
            return Fail<T, HilingualError>(error: forced).eraseToAnyPublisher()
        }
        #endif
        return Future<T, NetworkError> { [weak self] promise in
            self?.provider.request(target) { result in
                switch result {
                case .success(let response):
                    do {
                        switch response.statusCode {
                        case 200..<300:
                            let decoded = try JSONDecoder().decode(T.self, from: response.data)
                            promise(.success(decoded))

                        case 401:
                            promise(.failure(.unauthorized))

                        case 400..<500:
                            if let serverError = try? JSONDecoder().decode(ServerError.self, from: response.data) {
                                promise(.failure(.serverError(serverError)))
                            } else {
                                promise(.failure(.unknown))
                            }

                        case 500..<600:
                            promise(.failure(.serverError(ServerError(code: response.statusCode,
                                                                      message: "Server Error"))))

                        default:
                            promise(.failure(.unknown))
                        }
                    } catch {
                        promise(.failure(.decoding))
                    }

                case .failure(let error):
                    switch error {
                    case .underlying(let err, _):
                        promise(.failure(Self.transportError(from: err)))
                    default:
                        promise(.failure(.unknown))
                    }
                }
            }
        }
        .handleEvents(receiveCompletion: { completion in
            if case .failure(let error) = completion {
                print("❌ [네트워크에러] \(API.self) - \(target.path): \(error)에러 발생 ㅠ")
            }
        })
        .mapError { $0.toHilingualError() }
        .eraseToAnyPublisher()
    }

    public func requestPlain(_ target: API) -> AnyPublisher<Void, HilingualError> {
        #if DEBUG
        if let forced = NetworkDebug.forcedError(for: target.path) {
            return Fail<Void, HilingualError>(error: forced).eraseToAnyPublisher()
        }
        #endif
        return Future<Void, NetworkError> { [weak self] promise in
            self?.provider.request(target) { result in
                switch result {
                case .success(let response):
                    switch response.statusCode {
                    case 200..<300:
                        promise(.success(()))

                    case 401:
                        promise(.failure(.unauthorized))

                    case 400..<500:
                        if let serverError = try? JSONDecoder().decode(ServerError.self, from: response.data) {
                            promise(.failure(.serverError(serverError)))
                        } else {
                            promise(.failure(.unknown))
                        }

                    case 500..<600:
                        promise(.failure(.serverError(ServerError(code: response.statusCode,
                                                                  message: "Server Error"))))

                    default:
                        promise(.failure(.unknown))
                    }

                case .failure(let error):
                    if case let .underlying(err, _) = error {
                        promise(.failure(Self.transportError(from: err)))
                    } else {
                        promise(.failure(.networkFail))
                    }
                }
            }
        }
        .mapError { $0.toHilingualError() }
        .eraseToAnyPublisher()
    }
}
