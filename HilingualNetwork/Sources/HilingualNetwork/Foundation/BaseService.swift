//
//  BaseService.swift
//  Hilingual
//
//  Created by 성현주 on 7/3/25.
//

import Foundation
import Combine
import Moya

public class BaseService<API: TargetType> {

    // MARK: - Properties

    private let provider: MoyaProvider<API>

    // MARK: - Init

    public init(provider: MoyaProvider<API> = NetworkProvider.make()) {
        self.provider = provider
    }

    // MARK: - Request (Decodable Response)
    
    public func request<T: Decodable>(_ target: API, as type: T.Type) -> AnyPublisher<T, NetworkError> {
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
                                NotificationCenter.default.post(
                                    name: Notification.Name("ServerErrorOccurred"),
                                    object: nil,
                                    userInfo: ["message": serverError.message]
                                )
                                promise(.failure(.serverError(serverError)))
                            } else {
                                promise(.failure(.unknown))
                            }

                        case 500..<600:
                            NotificationCenter.default.post(
                                name: Notification.Name("ServerErrorOccurred"),
                                object: nil,
                                userInfo: ["message": "서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요."]
                            )
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
                        if let urlError = err as? URLError {
                            switch urlError.code {
                            case .timedOut:
                                promise(.failure(.timeout))
                            case .notConnectedToInternet, .cannotFindHost:
                                promise(.failure(.networkFail))
                            default:
                                promise(.failure(.networkFail))
                            }
                        } else {
                            promise(.failure(.unknown))
                        }

                    default:
                        promise(.failure(.unknown))
                    }
                }
            }
        }
        .handleEvents(receiveCompletion: { completion in
            if case .failure(let error) = completion {
                NotificationCenter.default.post(
                    name: Notification.Name("ServerErrorOccurred"),
                    object: nil,
                    userInfo: ["message": "앗 일시적인 오류가 발생했어요."]
                )
                print("❌ [네트워크에러] \(API.self) - \(target.path): \(error)에러 발생 ㅠ")
            }
        })
        .eraseToAnyPublisher()
    }

    ///삭제처럼 리스폰스 디코딩이  없는것들은 이함수로 호출하세요!! 
    public func requestPlain(_ target: API) -> AnyPublisher<Void, NetworkError> {
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
                            NotificationCenter.default.post(
                                name: Notification.Name("ServerErrorOccurred"),
                                object: nil,
                                userInfo: ["message": serverError.message]
                            )
                            promise(.failure(.serverError(serverError)))
                        } else {
                            promise(.failure(.unknown))
                        }

                    case 500..<600:
                        NotificationCenter.default.post(
                            name: Notification.Name("ServerErrorOccurred"),
                            object: nil,
                            userInfo: ["message": "서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요."]
                        )
                        promise(.failure(.serverError(ServerError(code: response.statusCode,
                                                                  message: "Server Error"))))

                    default:
                        promise(.failure(.unknown))
                    }

                case .failure:
                    promise(.failure(.networkFail))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
