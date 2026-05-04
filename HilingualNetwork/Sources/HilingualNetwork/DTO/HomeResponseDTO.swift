//
//  HomeResponseDTO.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Foundation

public struct HomeResponseDTO: Decodable {
    public let code: Int
    public let message: String
    public let data: String
}
