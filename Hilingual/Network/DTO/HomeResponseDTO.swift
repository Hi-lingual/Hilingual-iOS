//
//  HomeResponseDTO.swift
//  Hilingual
//
//  Created by 성현주 on 7/2/25.
//

import Foundation

struct HomeResponseDTO: Decodable {
    let code: Int
    let message: String
    let data: String
}
