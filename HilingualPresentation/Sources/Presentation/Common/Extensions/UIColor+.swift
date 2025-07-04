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
