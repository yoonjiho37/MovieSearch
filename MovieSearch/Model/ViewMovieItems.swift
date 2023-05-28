//
//  Domain.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/03/22.
//

import Foundation
import CoreData
import RxSwift

class BoxOfficeInfo {
    var boxOfficeType: BoxOfficeType
    var showRange: String
    var yearWeekTime: String?
    
    init(boxOfficeType: String, showRange: String, yearWeekTime: String?) {
        self.boxOfficeType = BoxOfficeType(rawValue: boxOfficeType) ?? .daily
        self.showRange = showRange
        self.yearWeekTime = yearWeekTime
    }
    
    init(localInfo: NSManagedObject?) {
        self.boxOfficeType = BoxOfficeType(rawValue: localInfo?.value(forKey: "boxOfficeType") as! String )!
        self.showRange = localInfo?.value(forKey: "showRange") as! String
        self.yearWeekTime = localInfo?.value(forKey: "yearWeekTime") as? String

    }
}

class ViewRankList {
    var boxOfficeType: BoxOfficeType
    var showRange: String
    var viewMovieList: [ViewMovieItems]
    var testViewMoviewList: [ViewMovieItems]
    
    init(boxOfficeType: BoxOfficeType, showRange: String, viewMovieList: [ViewMovieItems]) {
        self.boxOfficeType = boxOfficeType
        self.showRange = showRange
        self.viewMovieList = []
        self.testViewMoviewList = viewMovieList
    }
    
    init(localList: NSManagedObject?) {
        self.boxOfficeType = BoxOfficeType(rawValue: (localList?.value(forKey: "") as! String ) )!
        self.showRange = localList?.value(forKey: "") as! String
        self.viewMovieList = [ViewMovieItems]()
        self.testViewMoviewList = [ViewMovieItems]()
    }
}

class ViewMovieItems {
    var likeBoolean: Bool = false
    var watchLaterBoolean: Bool = false
    
    //MovieInfo
    let baseDate: String
    
    let movieId: String  //등록ID    K
    let title: String  //영화명    서편제
    let directorNm: String  //감독명    김지훈
    let actors: [String]  //배우명    하지원
    let company: String  //제작사    ㈜JK필름,CJ E&M Pictures
    let plot: String  //줄거리    제주도 남단, 7광구의.....
    let runtime: String  //대표상영시간    112
    let rating: String  //대표관람등급    15세관람가
    let genre: String  //kmdbUrl    액션,SF
    let posterURLs: [String]
    let repRlsDate: String
    
    //BoxOfficeItem
    var rank: Int
    let audiAcc: String // 누적관람인원
    let movieCode: String// 영화 코드
    let rankInten: String //        전일대비 순위의 증감분을 출력합니다.
    let rankOldAndNew: String //     랭킹에 신규진입여부를 출력합니다. “OLD” : 기존 , “NEW” : 신규
    var rankResult: String {
        if rankOldAndNew == "NEW" {
            return "New!"
        } else if rankInten.components(separatedBy: "")[0] == "-" {
            return "\(rankInten)↓"
        } else {
            return "\(rankInten)↑"
        }
    }
    
    
    init(localInfo: NSManagedObject?) {
        
        self.baseDate = localInfo?.value(forKey: "baseDate") as! String
        self.movieId = localInfo?.value(forKey: "movieId") as! String
        self.title = localInfo?.value(forKey: "title") as! String
        self.directorNm = localInfo?.value(forKey: "directorNm") as! String
        self.actors = localInfo?.value(forKey: "actors") as! [String]
        self.company = localInfo?.value(forKey: "company") as! String
        self.plot = localInfo?.value(forKey: "plot") as! String
        self.runtime = localInfo?.value(forKey: "runtime") as! String
        self.rating = localInfo?.value(forKey: "rating") as! String
        self.genre = localInfo?.value(forKey: "genre") as! String
        self.posterURLs = localInfo?.value(forKey: "posterURLs") as! [String]
        self.rank = localInfo?.value(forKey: "rank") as! Int
        self.repRlsDate = localInfo?.value(forKey: "repRlsDate") as! String
        self.audiAcc = localInfo?.value(forKey: "audiAcc") as! String
        self.movieCode = localInfo?.value(forKey: "movieCode") as! String
        self.rankInten = localInfo?.value(forKey: "rankInten") as! String
        self.rankOldAndNew = localInfo?.value(forKey: "rankInten") as! String
        
        self.likeBoolean = localInfo?.value(forKey: "likeBoolean") as! Bool
        self.watchLaterBoolean = localInfo?.value(forKey: "watchLaterBoolean") as! Bool
    }
    
    
    init(info: MovieInfo, boxOffice: BoxOfficeItems) {
        
        self.baseDate = info.statDate
        self.movieId = info.movieId
        self.title = info.title.removeBlank()
        self.directorNm = info.directors.director[0].directorNm.removeBlank()
        self.actors = info.actors.actor.map { $0.actorNm }
        self.company = info.company.removeBlank()
        self.plot = info.plots.plot[0].plotText
        self.runtime = info.runtime
        self.rating = info.rating.inputDataifBlank()
        self.genre = info.genre
        self.posterURLs = info.posters.components(separatedBy: "|")
        self.repRlsDate = info.repRlsDate.setDateFormat()
        
        self.audiAcc = boxOffice.audiAcc.setNumberFormatter()
        self.movieCode = boxOffice.movieCd
        self.rankInten = boxOffice.rankInten
        self.rankOldAndNew = boxOffice.rankOldAndNew
        self.rank = Int(boxOffice.rank)!
    }
    
    
    init(baseDate: String, movieId: String, title: String, directorNm: String, actors: [String], company: String, plot: String, runtime: String, rating: String, genre: String, posterURL: [String], repRlsDate: String, audiAcc: String, movieCode: String, rankInten: String, rankOldAndNew: String, rank: Int) {
        self.baseDate = baseDate
        self.movieId = movieId
        self.title = title
        self.directorNm = directorNm
        self.actors = actors
        self.company = company
        self.plot = plot
        self.runtime = runtime
        self.rating = rating
        self.genre = genre
        self.posterURLs = posterURL
        self.rank = rank
        self.repRlsDate = repRlsDate
        self.audiAcc = audiAcc
        self.movieCode = movieCode
        self.rankInten = rankInten
        self.rankOldAndNew = rankOldAndNew
    }
}


//class ViewMovieItems {
//    var likeBoolean: Bool = false
//    var watchLaterBoolean: Bool = false
//    var boxOfficeInfo: BoxOfficeInfo
//
//    //MovieInfo
//    let baseDate: String
//
//    let movieId: String  //등록ID    K
//    let title: String  //영화명    서편제
//    let directorNm: String  //감독명    김지훈
//    let actors: [String]  //배우명    하지원
//    let company: String  //제작사    ㈜JK필름,CJ E&M Pictures
//    let plot: String  //줄거리    제주도 남단, 7광구의.....
//    let runtime: String  //대표상영시간    112
//    let rating: String  //대표관람등급    15세관람가
//    let genre: String  //kmdbUrl    액션,SF
//    let posterURLs: [String]
//    let repRlsDate: String
//
//    //BoxOfficeItem
//    var rank: Int
//    let audiAcc: String // 누적관람인원
//    let movieCode: String// 영화 코드
//    let rankInten: String //        전일대비 순위의 증감분을 출력합니다.
//    let rankOldAndNew: String //     랭킹에 신규진입여부를 출력합니다. “OLD” : 기존 , “NEW” : 신규
//    var rankResult: String {
//        if rankOldAndNew == "NEW" {
//            return "New!"
//        } else if rankInten.components(separatedBy: "")[0] == "-" {
//            return "\(rankInten)↓"
//        } else {
//            return "\(rankInten)↑"
//        }
//    }
//
//
//    init(localInfo: NSManagedObject?) {
//        self.boxOfficeInfo = BoxOfficeInfo(localInfo: localInfo)
//
//        self.baseDate = localInfo?.value(forKey: "baseDate") as! String
//        self.movieId = localInfo?.value(forKey: "movieId") as! String
//        self.title = localInfo?.value(forKey: "title") as! String
//        self.directorNm = localInfo?.value(forKey: "directorNm") as! String
//        self.actors = localInfo?.value(forKey: "actors") as! [String]
//        self.company = localInfo?.value(forKey: "company") as! String
//        self.plot = localInfo?.value(forKey: "plot") as! String
//        self.runtime = localInfo?.value(forKey: "runtime") as! String
//        self.rating = localInfo?.value(forKey: "rating") as! String
//        self.genre = localInfo?.value(forKey: "genre") as! String
//        self.posterURLs = localInfo?.value(forKey: "posterURLs") as! [String]
//        self.rank = localInfo?.value(forKey: "rank") as! Int
//        self.repRlsDate = localInfo?.value(forKey: "repRlsDate") as! String
//        self.audiAcc = localInfo?.value(forKey: "audiAcc") as! String
//        self.movieCode = localInfo?.value(forKey: "movieCode") as! String
//        self.rankInten = localInfo?.value(forKey: "rankInten") as! String
//        self.rankOldAndNew = localInfo?.value(forKey: "rankInten") as! String
//
//        self.likeBoolean = localInfo?.value(forKey: "likeBoolean") as! Bool
//        self.watchLaterBoolean = localInfo?.value(forKey: "watchLaterBoolean") as! Bool
//    }
//
//
//    init(info: MovieInfo, boxOffice: BoxOfficeItems, boxOfficeInfo: BoxOfficeInfo) {
//        self.boxOfficeInfo = boxOfficeInfo
//
//        self.baseDate = info.statDate
//        self.movieId = info.movieId
//        self.title = info.title.removeBlank()
//        self.directorNm = info.directors.director[0].directorNm.removeBlank()
//        self.actors = info.actors.actor.map { $0.actorNm }
//        self.company = info.company.removeBlank()
//        self.plot = info.plots.plot[0].plotText
//        self.runtime = info.runtime
//        self.rating = info.rating.inputDataifBlank()
//        self.genre = info.genre
//        self.posterURLs = info.posters.components(separatedBy: "|")
//        self.repRlsDate = info.repRlsDate.setDateFormat()
//
//        self.audiAcc = boxOffice.audiAcc.setNumberFormatter()
//        self.movieCode = boxOffice.movieCd
//        self.rankInten = boxOffice.rankInten
//        self.rankOldAndNew = boxOffice.rankOldAndNew
//        self.rank = Int(boxOffice.rank)!
//    }
//
//
//    init(boxOfficeInfo: BoxOfficeInfo,baseDate: String, movieId: String, title: String, directorNm: String, actors: [String], company: String, plot: String, runtime: String, rating: String, genre: String, posterURL: [String], repRlsDate: String, audiAcc: String, movieCode: String, rankInten: String, rankOldAndNew: String, rank: Int) {
//        self.boxOfficeInfo = boxOfficeInfo
//        self.baseDate = baseDate
//        self.movieId = movieId
//        self.title = title
//        self.directorNm = directorNm
//        self.actors = actors
//        self.company = company
//        self.plot = plot
//        self.runtime = runtime
//        self.rating = rating
//        self.genre = genre
//        self.posterURLs = posterURL
//        self.rank = rank
//        self.repRlsDate = repRlsDate
//        self.audiAcc = audiAcc
//        self.movieCode = movieCode
//        self.rankInten = rankInten
//        self.rankOldAndNew = rankOldAndNew
//    }
//}
