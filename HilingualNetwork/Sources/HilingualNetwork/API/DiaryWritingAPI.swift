//
//  DiaryWritingAPI.swift
//  HilingualNetwork
//
//  Created by 신혜연 on 7/16/25.
//

import Foundation
import Moya

public enum DiaryWritingAPI {
    case postDiaryWriting(DiaryWritingRequestDTO)
}

extension DiaryWritingAPI: TargetType {

    public var baseURL: URL {
        return NetworkEnvironment.shared.baseURL
    }

    public var path: String {
        switch self {
        case .postDiaryWriting:
            return "/diaries"
        }
    }

    public var method: Moya.Method {
        return .post
    }

    public var task: Task {
        switch self {
        case .postDiaryWriting(let dto):
            var formData = [MultipartFormData]()

            if let textData = dto.originalText.data(using: .utf8) {
                formData.append(MultipartFormData(provider: .data(textData), name: "originalText"))
            }

            if let dateData = dto.date.data(using: .utf8) {
                formData.append(MultipartFormData(provider: .data(dateData), name: "date"))
            }

            formData.append(MultipartFormData(provider: .data(dto.imageFile),
                                              name: "imageFile",
                                              fileName: "image.jpg",
                                              mimeType: "image/jpeg"))

            return .uploadMultipart(formData)
        }
    }

    public var headers: [String: String]? {
        return [
            "Authorization": "Bearer \(UserDefaultHandler.accessToken)"
            // Moya가 Content-Type을 multipart/form-data로 자동 설정
        ]
    }

    public var sampleData: Data {
        return Data()
    }
}
