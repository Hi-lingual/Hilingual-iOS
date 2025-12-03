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
    
    public static func registerPretendardFonts() {
        for weight in Family.allCases {
            guard let fontURL = Bundle.module.url(forResource: "Pretendard-\(weight.rawValue)", withExtension: "ttf") else {
    #if DEBUG
                print("Pretendard-\(weight.rawValue).ttf 파일을 찾을 수 없습니다.")
    #endif
                continue
            }
            var error: Unmanaged<CFError>?
            if !CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error) {
    #if DEBUG
                if let cfError = error?.takeRetainedValue() {
                    print("Pretendard-\(weight.rawValue).ttf 등록 실패: \(cfError)")
                } else {
                    print("Pretendard-\(weight.rawValue).ttf 등록 실패 (원인 미상)")
                }
    #endif
            } else {
    #if DEBUG
                print("Pretendard-\(weight.rawValue).ttf 등록 성공")
    #endif
            }
        }
    }

    static func pretendard(weight: Family = .Regular, size: CGFloat) -> UIFont {
        if let font = UIFont(name: "Pretendard-\(weight.rawValue)", size: size) {
            return font
        } else {
            print("Pretendard-\(weight.rawValue) loading failed, fallback to system font")
            return .systemFont(ofSize: size)
        }
    }
    
    enum PretendardStyle {
        case head_sb_20
        case head_m_20
        case head_r_20
        case head_sb_18
        case head_m_18
        case head_r_18
        case head_sb_16
        
        case body_r_17
        case body_m_16
        case body_r_16
        case body_m_15
        case body_r_15
        case body_sb_14
        case body_m_14
        case body_r_14
        case body_m_12
        
        case cap_r_12
    }
    
    static func pretendard(_ style: PretendardStyle) -> UIFont {
        switch style {
        case .head_sb_20: return .pretendard(weight: .SemiBold, size: 20)
        case .head_m_20: return .pretendard(weight: .Medium, size: 20)
        case .head_r_20: return .pretendard(weight: .Regular, size: 20)
        case .head_sb_18: return .pretendard(weight: .SemiBold, size: 18)
        case .head_m_18: return .pretendard(weight: .Medium, size: 18)
        case .head_r_18: return .pretendard(weight: .Regular, size: 18)
        case .head_sb_16: return .pretendard(weight: .SemiBold, size: 16)
            
        case .body_r_17: return .pretendard(weight: .Regular, size: 17)
        case .body_m_16: return .pretendard(weight: .Medium, size: 16)
        case .body_r_16: return .pretendard(weight: .Regular, size: 16)
        case .body_m_15: return .pretendard(weight: .Medium, size: 15)
        case .body_r_15: return .pretendard(weight: .Regular, size: 15)
        case .body_sb_14: return .pretendard(weight: .SemiBold, size: 14)
        case .body_m_14: return .pretendard(weight: .Medium, size: 14)
        case .body_r_14: return .pretendard(weight: .Regular, size: 14)
        case .body_m_12: return .pretendard(weight: .Medium, size: 12)
            
        case .cap_r_12: return .pretendard(weight: .Regular, size: 12)
        }
    }
}
