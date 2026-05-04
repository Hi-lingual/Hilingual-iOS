//
//  DefaultPresignedImageUploadRepository.swift
//  HilingualData
//
//  Created by 성현주 on 9/6/25.
//

import Foundation
import Combine

import HilingualDomain
import HilingualNetwork

public final class DefaultPresignedImageUploadRepository: PresignedImageUploadRepository {

    private let service: PresignedURLService

    public init(service: PresignedURLService) {
        self.service = service
    }

    public func uploadImage(data: Data, contentType: String, purpose: String) -> AnyPublisher<String, Error> {
        return service.requestPresignedURL(contentType: contentType, purpose: purpose)
            .flatMap { [service] fileKey, uploadUrl in
                service.uploadImageToS3(imageData: data, uploadUrl: uploadUrl, contentType: contentType)
                    .map { fileKey }
            }
            .eraseToAnyPublisher()
    }
}
