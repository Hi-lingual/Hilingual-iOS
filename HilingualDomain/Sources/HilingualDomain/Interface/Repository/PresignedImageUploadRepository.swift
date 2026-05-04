//
//  PresignedImageUploadRepository.swift
//  HilingualDomain
//
//  Created by 성현주 on 9/6/25.
//


import Foundation
import Combine

public protocol PresignedImageUploadRepository {
    func uploadImage(data: Data, contentType: String, purpose: String) -> AnyPublisher<String, Error>
}
