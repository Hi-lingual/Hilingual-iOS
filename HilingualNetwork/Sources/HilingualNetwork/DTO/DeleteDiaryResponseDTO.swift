//
//  DeleteDiaryResponseDTO.swift
//  HilingualNetwork
//
//  Created by 진소은 on 8/27/25.
//

public struct DeleteDiaryResponseDTO: Decodable {
    public let code: Int
    public let data: String?
    public let message: String
}
