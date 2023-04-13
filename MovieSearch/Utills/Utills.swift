//
//  Utills.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/04/13.
//

import Foundation

extension String {
    func setYesterDay() -> Self {
        let calender = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        var yesterDay = DateComponents()
        yesterDay.day = -1
        
        guard let yesterDay = calender.date(byAdding: yesterDay, to: Date()) else { return ""}
        return dateFormatter.string(from: yesterDay)
    }
}

extension Date {
    func setY() -> String {
        let calender = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        var yesterDay = DateComponents()
        yesterDay.day = -1
        
        guard let yesterDay = calender.date(byAdding: yesterDay, to: Self.now) else { return ""}
        return dateFormatter.string(from: yesterDay)
    }
}
