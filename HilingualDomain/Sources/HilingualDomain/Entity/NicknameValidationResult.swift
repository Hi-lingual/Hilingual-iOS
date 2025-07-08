//
//  NicknameValidationResult.swift
//  HilingualDomain
//
//  Created by 성현주 on 7/8/25.
//

import Foundation

public enum NicknameValidationResult: Equatable {
    case valid
    case tooShort
    case containsInvalidCharacters
    case empty
}
