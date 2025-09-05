//
//  UploadImageUseCase.swift
//  HilingualDomain
//
//  Created by 성현주 on 9/6/25.
//

import Combine
import Foundation

public protocol UploadImageUseCase {
    /// - Parameters:
    ///   - data: 이미지 파일 데이터
    ///   - contentType: "image/jpeg" 등
    ///   - purpose: "PROFILE_UPLOAD" | "PROFILE_UPDATE" | "DIARY_IMAGE"
    /// - Returns: 업로드 후 fileKey 반환
    /// 위형식에 맞춰주세요!
    func execute(data: Data, contentType: String, purpose: String) -> AnyPublisher<String, Error>
}

public final class DefaultUploadImageUseCase: UploadImageUseCase {
    private let repository: PresignedImageUploadRepository

    public init(repository: PresignedImageUploadRepository) {
        self.repository = repository
    }

    public func execute(data: Data, contentType: String, purpose: String) -> AnyPublisher<String, Error> {
        return repository.uploadImage(data: data, contentType: contentType, purpose: purpose)
    }
}
