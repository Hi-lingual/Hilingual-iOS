//
//  DefaultPresignedURLService.swift
//  HilingualNetwork
//
//  Created by 성현주 on 9/7/25.
//

import Foundation
import Moya
import Combine

public protocol PresignedURLService {
    func requestPresignedURL(contentType: String, purpose: String) -> AnyPublisher<(fileKey: String, uploadUrl: String), Error>
    func uploadImageToS3(imageData: Data, uploadUrl: String, contentType: String) -> AnyPublisher<Void, Error>
}

public final class DefaultPresignedURLService: BaseService<PresignedURLAPI>, PresignedURLService {
    public func requestPresignedURL(contentType: String, purpose: String) -> AnyPublisher<(fileKey: String, uploadUrl: String), Error> {
        let requestDTO = PresignedURLRequestDTO(contentType: contentType, purpose: purpose)

        return request(.getPresignedURL(request: requestDTO), as: PresignedURLResponseDTO.self)
            .map { ($0.data.fileKey, $0.data.uploadUrl) }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

    public func uploadImageToS3(imageData: Data, uploadUrl: String, contentType: String) -> AnyPublisher<Void, Error> {
        var request = URLRequest(url: URL(string: uploadUrl)!)
        request.httpMethod = "PUT"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        request.httpBody = imageData

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { result in
                guard let response = result.response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                    throw URLError(.badServerResponse)
                }
            }
            .eraseToAnyPublisher()
    }
}
