//
//  ProfileImageRequestDTO.swift
//  HilingualNetwork
//
//  Created by 성현주 on 9/9/25.
//

import Foundation

public struct ProfileImageRequestDTO: Encodable {
    public struct Image: Encodable {
        public let fileKey: String
        public let purpose: String

        public init(fileKey: String, purpose: String = "PROFILE_UPDATE") {
            self.fileKey = fileKey
            self.purpose = purpose
        }
    }

    public let image: Image

    public init(fileKey: String) {
        self.image = Image(fileKey: fileKey)
    }
}
