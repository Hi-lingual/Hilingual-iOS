//
//  Chip.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 7/6/25.
//

import UIKit

enum ChipType {
    case verb
    case noun
    case pronoun
    case adjective
    case adverb
    case preposition
    case conjunction
    case interjection
    case phrase
    case clause
    case expression
    case me
    case ai
    
    var title: String {
        switch self {
        case .verb: return "동사"
        case .noun: return "명사"
        case .pronoun: return "대명사"
        case .adjective: return "형용사"
        case .adverb: return "부사"
        case .preposition: return "전치사"
        case .conjunction: return "접속사"
        case .interjection: return "감탄사"
        case .phrase: return "숙어"
        case .clause: return "속어"
        case .expression: return "구"
        case .me: return "me"
        case .ai: return "AI"
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .verb: return .hilingualOrange
        case .noun: return .noun_bg
        case .pronoun: return .pronoun_bg
        case .adjective: return .adj_bg
        case .adverb: return .adverb_bg
        case .preposition: return .preposition_bg
        case .conjunction: return .hilingualBlue
        case .interjection: return .interjection_bg
        case .phrase, .clause, .expression: return .gray100
        case .me: return .hilingualBlack
        case .ai: return .hilingualOrange
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .noun: return .hilingualBlue
        case .pronoun: return .pronoun_text
        case .adjective: return .adj_text
        case .adverb: return .adverb_text
        case .preposition: return .preposition_text
        case .phrase, .clause, .expression: return .gray400
        default:
            return .white
        }
    }
}
