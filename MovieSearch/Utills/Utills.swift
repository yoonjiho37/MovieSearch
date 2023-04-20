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
    
    func getLastSunday() -> String {
        let calender = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.dateFormat = "yyyyMMdd E"
        
        let nowDate = dateFormatter.string(from: Date()).split(separator: " ")[1]
        var lastSunday = DateComponents()

        if nowDate == "월" {
            lastSunday.day = -1
        } else  if nowDate == "화" {
            lastSunday.day = -2
        } else  if nowDate == "수" {
            lastSunday.day = -3
        } else  if nowDate == "목" {
            lastSunday.day = -4
        } else  if nowDate == "금" {
            lastSunday.day = -5
        } else  if nowDate == "토" {
            lastSunday.day = -6
        } else  if nowDate == "일" {
            lastSunday.day = -7
        }
            
        
        
        guard let lastSunday = calender.date(byAdding: lastSunday, to: Date.now) else { return "" }
        let dateda = dateFormatter.string(from: lastSunday).components(separatedBy: " ")[0]
        return dateda
    }
}
