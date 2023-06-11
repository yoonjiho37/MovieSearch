//
//  Utills.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/04/13.
//

import Foundation
import UIKit



extension String {
    func removeBlank() -> String {
        let firstBlank = self.components(separatedBy: " !HE ").joined()
        let scondBlank = firstBlank.components(separatedBy: " !HS ").joined()
        let frontBlank = scondBlank.trimmingCharacters(in: .whitespaces)
        
        return frontBlank
    }
    func removeChactors() -> String {
        return self.components(separatedBy: ["!", "?", " ", "<", ">", ","]).joined()
    }
    func inputDataifBlank() -> String {
        if self == "" {
            return "전체이용가"
        } else {
            return self
        }
    }
    
    func setUIImage() -> UIImage? {
        let value = self
        switch value {
        case "12세관람가":
            return UIImage(named: "ic_12")
        case "15세관람가":
            return UIImage(named: "ic_15")
        case "18세관람가(청소년관람불가)":
            return UIImage(named: "ic_19")
        case "전체관람가":
            return UIImage(named: "ic_all")
        default:
            return UIImage(named: "ic_all")
        }
    }
    
    func setNumberFormatter() -> String {
        let int = Int(self) ?? 2222222
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value: int)) ?? "1111.11.11"
    }
    
    func setDateFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        guard let firstDate = dateFormatter.date(from: self) else { return "" }
        let commaDateFormatter = DateFormatter()
        commaDateFormatter.dateFormat = "yyyy.MM.dd"
        let date = commaDateFormatter.string(from: firstDate)
        return date
    }
}

extension Bool {
    func toggle() -> Bool {
        print("will Set => \(self)")
        if self {
            let result: Bool = false
            print("did Set => \(result)")

            return result
        } else {
            let result: Bool = true
            print("did Set => \(result)")
            return result
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
