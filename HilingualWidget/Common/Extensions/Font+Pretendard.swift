//
//  Font+Pretendard.swift
//  HilingualWidget
//
//  Created by youngseo on 8/22/26.
//

import SwiftUI

// MARK: - Extensions

extension Font {
    enum PretendardFamily: String {
        case medium = "Pretendard-Medium"
        case regular = "Pretendard-Regular"
        case semiBold = "Pretendard-SemiBold"
        case bold = "Pretendard-Bold"
    }

    enum PretendardStyle {
        case head_b_36
        case head_b_26
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

    static func pretendard(weight: PretendardFamily = .regular, size: CGFloat) -> Font {
        .custom(weight.rawValue, size: size)
    }

    static func pretendard(_ style: PretendardStyle) -> Font {
        switch style {
        case .head_sb_20: return .pretendard(weight: .semiBold, size: 20)
        case .head_m_20: return .pretendard(weight: .medium, size: 20)
        case .head_r_20: return .pretendard(weight: .regular, size: 20)
        case .head_sb_18: return .pretendard(weight: .semiBold, size: 18)
        case .head_m_18: return .pretendard(weight: .medium, size: 18)
        case .head_r_18: return .pretendard(weight: .regular, size: 18)
        case .head_sb_16: return .pretendard(weight: .semiBold, size: 16)
        case .head_b_36: return .pretendard(weight: .bold, size: 36)
        case .head_b_26: return .pretendard(weight: .bold, size: 26)

        case .body_r_17: return .pretendard(weight: .regular, size: 17)
        case .body_m_16: return .pretendard(weight: .medium, size: 16)
        case .body_r_16: return .pretendard(weight: .regular, size: 16)
        case .body_m_15: return .pretendard(weight: .medium, size: 15)
        case .body_r_15: return .pretendard(weight: .regular, size: 15)
        case .body_sb_14: return .pretendard(weight: .semiBold, size: 14)
        case .body_m_14: return .pretendard(weight: .medium, size: 14)
        case .body_r_14: return .pretendard(weight: .regular, size: 14)
        case .body_m_12: return .pretendard(weight: .medium, size: 12)

        case .cap_r_12: return .pretendard(weight: .regular, size: 12)
        }
    }
}
