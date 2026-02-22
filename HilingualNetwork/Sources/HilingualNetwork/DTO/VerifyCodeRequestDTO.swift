//
//  VerifyCodeRequestDTO.swift
//  HilingualNetwork
//
//  Created by 성현주 on 9/16/25.
//


public struct VerifyCodeRequestDTO: Encodable {
    public let code: String

    public init(code: String) {
        self.code = code
    }
}
