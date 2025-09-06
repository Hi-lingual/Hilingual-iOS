//
//  PresignedURLResponseDTO.swift
//  HilingualNetwork
//
//  Created by 성현주 on 9/6/25.
//

public struct PresignedURLResponseDTO: Decodable {
    public let code: Int
    public let message: String
    public let data: PresignedData

    public struct PresignedData: Decodable {
        public let fileKey: String
        public let uploadUrl: String
    }
}

public struct PresignedURLRequestDTO: Encodable {
    public let contentType: String
    public let purpose: String

    public init(contentType: String, purpose: String) {
        self.contentType = contentType
        self.purpose = purpose
    }
}
