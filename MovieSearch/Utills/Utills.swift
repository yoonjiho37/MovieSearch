//
//  Utills.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/04/13.
//

import Foundation

extension String {
    func removeBlank() -> String {
        let firstBlack = self.components(separatedBy: " !HE").joined()
        return firstBlack.components(separatedBy: "  !HS ").joined()
    }
    func inputDataifBlank() -> String {
        if self == "" {
            return "전체이용가"
        } else {
            return self
        }
        
    }
}


extension Date {
    func getYesterday() -> String {
        let calender = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        var yesterDay = DateComponents()
        yesterDay.day = -1
        
        guard let yesterDay = calender.date(byAdding: yesterDay, to: Self.now) else { return ""}
        return dateFormatter.string(from: yesterDay)
    }
}
