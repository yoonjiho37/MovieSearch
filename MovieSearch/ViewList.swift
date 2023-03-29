//
//  Domain.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/03/22.
//

import Foundation
import RxSwift

class ViewList {
    let rnum : String //       순번을 출력합니다.
    let rank : String //       해당일자의 박스오피스 순위를 출력합니다.
    let rankInten: String //        전일대비 순위의 증감분을 출력합니다.
    let rankOldAndNew: String //     랭킹에 신규진입여부를 출력합니다. “OLD” : 기존 , “NEW” : 신규
    let movieCd: String //        영화의 대표코드를 출력합니다.
    let movieNm: String //        영화명(국문)을 출력합니다.
    let openDt: String //        영화의 개봉일을 출력합니다.
    let audiAcc: String //       누적관객수를 출력합니다.
    
    init(_ item: BoxOfficeItems) {
        rnum = item.rnum
        rank = item.rank
        rankInten = item.rankInten
        rankOldAndNew = item.rankOldAndNew
        movieCd = item.movieCd
        movieNm = item.movieNm
        openDt = item.openDt
        audiAcc = item.audiAcc
    }
    
    init(rnum: String, rank: String, rankInten: String, rankOldAndNew: String, movieCd: String, movieNm: String, openDt: String, audiAcc: String) {
        self.rnum = rnum
        self.rank = rank
        self.rankInten = rankInten
        self.rankOldAndNew = rankOldAndNew
        self.movieCd = movieCd
        self.movieNm = movieNm
        self.openDt = openDt
        self.audiAcc = audiAcc
    }
}

extension ViewList: Equatable {
    static func == (lhs: ViewList, rhs: ViewList) -> Bool {
        return lhs.rnum == rhs.rnum && lhs.rank == rhs.rank && lhs.rankInten == rhs.rankInten && lhs.rankOldAndNew == rhs.rankOldAndNew && lhs.movieCd == rhs.movieCd && lhs.movieNm == rhs.movieNm && lhs.openDt == rhs.openDt && lhs.audiAcc == rhs.audiAcc
    }
}
