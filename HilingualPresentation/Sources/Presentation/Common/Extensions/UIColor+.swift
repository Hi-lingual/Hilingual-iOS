//
//  UIColor+.swift
//  HilingualPresentation
//
//  Created by 신혜연 on 7/5/25.
//

import UIKit

enum HilingualColor: String {
    
    case hilingualBlack = "HilingualBlack"
    case hilingualOrange = "HilingualOrange"
    case hilingualBlue = "HilingualBlue"
    
    case noun_bg = "Noun_bg"
    case pronoun_bg = "Pronoun_bg"
    case adj_bg = "Adj_bg"
    case adverb_bg = "Adverb_bg"
    case preposition_bg = "Preposition_bg"
    case interjection_bg = "Interjection_bg"
    case pronoun_text = "Pronoun_text"
    case adj_text = "Adj_text"
    case adverb_text = "Adverb_text"
    case preposition_text = "Preposition_text"
    
    case black = "Black"
    case gray850 = "Gray850"
    case gray700 = "Gray700"
    case gray500 = "Gray500"
    case gray400 = "Gray400"
    case gray300 = "Gray300"
    case gray200 = "Gray200"
    case gray100 = "Gray100"
    case white = "White"
    case dim = "Dim"
    
    case alertRed = "AlertRed"
    case infoBlue = "InfoBlue"
}

extension UIColor {
    static func color(_ color: HilingualColor) -> UIColor {
        return UIColor(named: color.rawValue, in: .module, compatibleWith: nil) ?? .clear
    }
}

extension UIColor {
    static var hilingualBlack: UIColor { .color(.hilingualBlack) }
    static var hilingualOrange: UIColor { .color(.hilingualOrange) }
    static var hilingualBlue: UIColor { .color(.hilingualBlue) }
    
    static var noun_bg: UIColor { .color(.noun_bg) }
    static var pronoun_bg: UIColor { .color(.pronoun_bg) }
    static var adj_bg: UIColor { .color(.adj_bg) }
    static var adverb_bg: UIColor { .color(.adverb_bg) }
    static var preposition_bg: UIColor { .color(.preposition_bg) }
    static var interjection_bg: UIColor { .color(.interjection_bg) }
    static var pronoun_text: UIColor { .color(.pronoun_text) }
    static var adj_text: UIColor { .color(.adj_text) }
    static var adverb_text: UIColor { .color(.adverb_text) }
    static var preposition_text: UIColor { .color(.preposition_text) }
    
    static var black: UIColor { .color(.black) }
    static var gray850: UIColor { .color(.gray850) }
    static var gray700: UIColor { .color(.gray700) }
    static var gray500: UIColor { .color(.gray500) }
    static var gray400: UIColor { .color(.gray400) }
    static var gray300: UIColor { .color(.gray300) }
    static var gray200: UIColor { .color(.gray200) }
    static var gray100: UIColor { .color(.gray100) }
    static var white: UIColor { .color(.white) }
    static var dim: UIColor { .color(.dim) }
    
    static var alertRed: UIColor { .color(.alertRed) }
    static var infoBlue: UIColor { .color(.infoBlue) }
}
