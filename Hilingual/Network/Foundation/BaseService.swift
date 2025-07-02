//
//  BaseService.swift
//  Hilingual
//
//  Created by 성현주 on 7/3/25.
//

import Foundation
import Combine
import Moya

class BaseService<API: TargetType> {
    let provider: MoyaProvider<API>

    init(provider: MoyaProvider<API> = MoyaProvider<API>(plugins: [MoyaLoggerPlugin()])) {
        self.provider = provider
    }

    func request<T: Decodable>(_ target: API, as type: T.Type) -> AnyPublisher<T, NetworkError> {
        return Future<T, NetworkError> { [weak self] promise in
            self?.provider.request(target) { result in
                switch result {
                case .success(let response):
                    // 상태 코드 검사
                    do {
                        switch response.statusCode {
                        case 200..<300:
                            let decoded = try JSONDecoder().decode(T.self, from: response.data)
                            promise(.success(decoded))
                        case 401:
                            promise(.failure(.unauthorized))
                        case 403:
                            promise(.failure(.forbidden))
                        case 404:
                            promise(.failure(.notFound))
                        default:
                            if let serverError = try? JSONDecoder().decode(ServerError.self, from: response.data) {
                                promise(.failure(.serverError(serverError)))
                            } else {
                                promise(.failure(.unknown))
                            }
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
                print("❌ [네트워크에러] \(API.self) - \(target.path): \(error)에러 발생 ㅠ")
            }
        })
        .eraseToAnyPublisher()
    }
}
