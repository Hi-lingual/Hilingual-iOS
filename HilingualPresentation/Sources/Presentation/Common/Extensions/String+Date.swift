//
//  String+Date.swift
//  HilingualPresentation
//
//  Created by youngseo on 4/15/26.
//

import Foundation

extension String {
    
    func toAPIDate() -> String? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일 EEEE"
        
        guard let parsedDate = formatter.date(from: self) else { return nil }
        
        let calendar = Calendar.current
        let month = calendar.component(.month, from: parsedDate)
        let day = calendar.component(.day, from: parsedDate)
        let targetWeekday = calendar.component(.weekday, from: parsedDate)
        
        let currentYear = calendar.component(.year, from: Date())
        
        for year in stride(from: currentYear, through: currentYear - 2, by: -1) {
            var components = DateComponents()
            components.year = year
            components.month = month
            components.day = day
            
            if let candidate = calendar.date(from: components),
               calendar.component(.weekday, from: candidate) == targetWeekday {
                
                return candidate.toFormattedString("yyyy-MM-dd")
            }
        }
        
        var fallback = DateComponents()
        fallback.year = currentYear
        fallback.month = month
        fallback.day = day
        
        guard let fallbackDate = calendar.date(from: fallback) else { return nil }
        return fallbackDate.toFormattedString("yyyy-MM-dd")
    }
}
