//
//  BoxOffice.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/03/22.
//

import Foundation

enum BoxOfficeType: String, Codable {
    case daily = "일별 박스오피스"
    case weekly = "주간 박스오피스"
    case weekEnd = "주말 박스오피스"
}

struct BoxOffice: Codable {
    var boxOfficeResult: BoxOfficeResult
}

struct BoxOfficeResult: Codable {
    var boxofficeType: BoxOfficeType //        박스오피스 종류를 출력합니다.
    let showRange: String //        박스오피스 조회 일자를 출력합니다.
    var dailyBoxOfficeList : [BoxOfficeItems]
    
}

struct BoxOfficeWeekly: Codable {
    var boxOfficeResult: BoxOfficeWeeklyReult
}

struct BoxOfficeWeeklyReult: Codable {
    var boxofficeType: String //        박스오피스 종류를 출력합니다.
    let showRange: String //        박스오피스 조회 일자를 출력합니다.
    let yearWeekTime: String
    var weeklyBoxOfficeList : [BoxOfficeItems]
}


struct BoxOfficeItems: Codable {
    let rnum : String //       순번을 출력합니다.
    let rank : String //       해당일자의 박스오피스 순위를 출력합니다.
    let rankInten: String //        전일대비 순위의 증감분을 출력합니다.
    let rankOldAndNew: String //     랭킹에 신규진입여부를 출력합니다. “OLD” : 기존 , “NEW” : 신규
    let movieCd: String //        영화의 대표코드를 출력합니다.
    let movieNm: String //        영화명(국문)을 출력합니다.
    let openDt: String //        영화의 개봉일을 출력합니다.
    let salesAmt: String //        해당일의 매출액을 출력합니다.
    let salesShare: String //       해당일자 상영작의 매출총액 대비 해당 영화의 매출비율을 출력합니다.
    let salesInten: String //        전일 대비 매출액 증감분을 출력합니다.
    let salesChange: String //        전일 대비 매출액 증감 비율을 출력합니다.
    let salesAcc: String //        누적매출액을 출력합니다.
    let audiCnt: String //       해당일의 관객수를 출력합니다.
    let audiInten: String //       전일 대비 관객수 증감분을 출력합니다.
    let audiChange: String //       전일 대비 관객수 증감 비율을 출력합니다.
    let audiAcc: String //       누적관객수를 출력합니다.
    let scrnCnt: String //       해당일자에 상영한 스크린수를 출력합니다.
    let showCnt: String //       해당일자에 상영된 횟수를 출력합니다.
}

extension BoxOfficeItems: Equatable {
    static func == (lhs: BoxOfficeItems, rhs: BoxOfficeItems) -> Bool {
        return lhs.rnum == rhs.rnum && lhs.rank == rhs.rank && lhs.rankInten == rhs.rankInten && lhs.rankOldAndNew == rhs.rankOldAndNew && lhs.movieCd == rhs.movieCd && lhs.movieNm == rhs.movieNm && lhs.openDt == rhs.openDt && lhs.salesAmt == rhs.salesAmt && lhs.salesShare == rhs.salesShare && lhs.salesInten == rhs.salesInten && lhs.salesChange == rhs.salesChange && lhs.salesAcc == rhs.salesAcc && lhs.audiCnt == rhs.audiCnt && lhs.audiInten == rhs.audiInten && lhs.audiChange == rhs.audiChange && lhs.audiAcc == rhs.audiAcc && lhs.scrnCnt == rhs.scrnCnt && lhs.showCnt == rhs.showCnt
    }
}

extension BoxOfficeResult: Equatable {
    static func == (lhs: BoxOfficeResult, rhs: BoxOfficeResult) -> Bool {
        return lhs.boxofficeType == rhs.boxofficeType && lhs.showRange == rhs.showRange
    }
}
