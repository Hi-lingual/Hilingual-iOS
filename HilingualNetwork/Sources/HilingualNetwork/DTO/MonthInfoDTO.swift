//
//  MonthInfoDTO.swift
//  HilingualNetwork
//
//  Created by 조영서 on 7/16/25.
//

import Foundation

public struct MonthInfoDTO: Decodable {
    public let code: Int
    public let data: DateListDTO?
    public let message: String
}

public struct DateListDTO: Decodable {
    public let dateList: [DateDTO]
}

public struct DateDTO: Decodable {
    public let date: String
}
