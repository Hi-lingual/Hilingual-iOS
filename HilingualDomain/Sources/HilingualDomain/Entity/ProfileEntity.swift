//
//  ProfileEntity.swift
//  HilingualDomain
//
//  Created by 성현주 on 7/15/25.
//

public struct ProfileEntity {
    public let nickname: String
    public let adAlarmAgree: Bool
    public let image: ImageFile?

    public init(nickname: String, adAlarmAgree: Bool, fileKey: String?) {
        self.nickname = nickname
        self.adAlarmAgree = adAlarmAgree
        self.image = fileKey.map { ImageFile(fileKey: $0) }
    }

    public struct ImageFile {
        public let fileKey: String
        public let purpose: String

        public init(fileKey: String, purpose: String = "PROFILE_UPLOAD") {
            self.fileKey = fileKey
            self.purpose = purpose
        }
    }
}
