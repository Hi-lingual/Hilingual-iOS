//
//  String+Case.swift
//  HilingualCore
//

import Foundation

extension String {
    var camelToSnakeCased: String {
        var result = ""
        for character in self {
            if character.isUppercase {
                if !result.isEmpty {
                    result.append("_")
                }
                result.append(character.lowercased())
            } else {
                result.append(character)
            }
        }
        return result
    }
}
