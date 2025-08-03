//
//  UIFont+.swift
//  HilingualPresentation
//
//  Created by 진소은 on 7/5/25.
//

import UIKit

extension UIFont {
    
    enum Family: String, CaseIterable {
        case Bold, ExtraBold, ExtraLight, Heavy, Light, Medium, Regular, SemiBold, Thin
    }
    
    public static func registerSuitFonts() {
        for weight in Family.allCases {
            guard let fontURL = Bundle.module.url(forResource: "SUIT-\(weight.rawValue)", withExtension: "ttf") else {
    #if DEBUG
                print("SUIT-\(weight.rawValue).ttf 파일을 찾을 수 없습니다.")
    #endif
                continue
            }
            var error: Unmanaged<CFError>?
            if !CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error) {
    #if DEBUG
                if let cfError = error?.takeRetainedValue() {
                    print("SUIT-\(weight.rawValue).ttf 등록 실패: \(cfError)")
                } else {
                    print("SUIT-\(weight.rawValue).ttf 등록 실패 (원인 미상)")
                }
    #endif
            } else {
    #if DEBUG
                print("SUIT-\(weight.rawValue).ttf 등록 성공")
    #endif
            }
        }
    }

    static func suit(weight: Family = .Regular, size: CGFloat) -> UIFont {
        if let font = UIFont(name: "SUIT-\(weight.rawValue)", size: size) {
            return font
        } else {
            print("SUIT-\(weight.rawValue) loading failed, fallback to system font")
            return .systemFont(ofSize: size)
        }
    }
    
    enum SuitStyle {
        case head_b_20
        case head_sb_20
        case head_b_18
        case head_m_18
        case head_b_16
        
        case body_m_20
        case body_r_18
        case body_sb_16
        case body_m_16
        case body_r_16
        case body_b_14
        case body_sb_14
        case body_m_14
        case body_sb_12
        
        case caption_r_14
        case caption_m_12
        case caption_r_12
    }
    
    static func suit(_ style: SuitStyle) -> UIFont {
        switch style {
        case .head_b_20: return .suit(weight: .Bold, size: 20)
        case .head_sb_20: return .suit(weight: .SemiBold, size: 20)
        case .head_b_18: return .suit(weight: .Bold, size: 18)
        case .head_m_18: return .suit(weight: .Medium, size: 18)
        case .head_b_16: return .suit(weight: .Bold, size: 16)
            
        case .body_m_20: return .suit(weight: .Medium, size: 20)
        case .body_r_18: return .suit(weight: .Regular, size: 18)
        case .body_sb_16: return .suit(weight: .SemiBold, size: 16)
        case .body_m_16: return .suit(weight: .Medium, size: 16)
        case .body_r_16: return .suit(weight: .Regular, size: 16)
        case .body_b_14: return .suit(weight: .Bold, size: 14)
        case .body_sb_14: return .suit(weight: .SemiBold, size: 14)
        case .body_m_14: return .suit(weight: .Medium, size: 14)
        case .body_sb_12: return .suit(weight: .SemiBold, size: 12)
            
        case .caption_r_14: return .suit(weight: .Regular, size: 14)
        case .caption_m_12: return .suit(weight: .Medium, size: 12)
        case .caption_r_12: return .suit(weight: .Regular, size: 12)
        }
    }
}
