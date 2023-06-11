//
//  Domain.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/03/23.
//

import Foundation
import RxSwift

protocol DomainType {
    func checkBoxOfficeWeely(type: BoxOfficeType) -> Observable<ViewRankList>
    func setSearchResultToViewMovieList(_ queryValue: String?, _ boxOfficeItem: BoxOfficeItems?) -> Observable<ViewMovieItems>
    func setSearchResultsToViewMovieList(queryValue: String) -> Observable<[String]>
}
enum FetchFor {
    case search
    case boxofficeList
}

class Domain: DomainType {
    
    func checkBoxOfficeWeely(type: BoxOfficeType) -> Observable<ViewRankList> {
        switch type {
        case .daily:
            return setBoxOfficeList()
        case .weekly, .weekEnd:
            return setBoxOfficeListWeely(type: type)
        }
    }
    
    func setBoxOfficeList() -> Observable<ViewRankList> {
        let observableList = APIService.fetchBoxOfficeRx()
            .flatMap { result -> Observable<ViewRankList> in
                let resultItems = ViewRankList(boxOfficeType: result.boxofficeType, showRange: result.showRange, viewMovieList: [])
                let obs = result.dailyBoxOfficeList
                    .map { items in
                        self.setSearchResultToViewMovieList(nil,items)
                    }
                let resultObs = Observable.just(resultItems)
                let listObs = Observable.combineLatest(obs)
                
                return Observable.zip(resultObs, listObs) { ranklist, list -> ViewRankList in
                    let result = ranklist
                    result.viewMovieList = list
                    return result
                }
            }
        return observableList
    }

    
    func setBoxOfficeListWeely(type: BoxOfficeType) -> Observable<ViewRankList> {
        let observableList = APIService.fetchBoxOfficeWeelyRx(type: type)
            .flatMap { result -> Observable<ViewRankList> in
                let resultItems = ViewRankList(boxOfficeType: BoxOfficeType(rawValue: result.boxofficeType) ?? .daily, showRange: result.showRange, viewMovieList: [])
                let obs = result.weeklyBoxOfficeList
                    .map { items in
                        self.setSearchResultToViewMovieList(nil, items)
                    }
                let resultObs = Observable.just(resultItems)
                let listObs = Observable.combineLatest(obs)
                
                return Observable.zip(resultObs, listObs) { ranklist, list -> ViewRankList in
                    let result = ranklist
                    result.viewMovieList = list
                    
                    return result
                }
            }
        return observableList
    }
    
    func setSearchResultToViewMovieList(_ queryValue: String?, _ boxOfficeItem: BoxOfficeItems?) -> Observable<ViewMovieItems> {
        if boxOfficeItem == nil {
            print("VM3 ]] ==> \(queryValue)")
            return APIService.fetchSearchResultRx(queryValue: queryValue!.removeChactors() )
                .map { ViewMovieItems(info: $0, boxOffice: nil)}
        } else {
            return APIService.fetchSearchResultRx(queryValue: boxOfficeItem!.movieNm.removeBlank().removeChactors() )
                .map { ViewMovieItems(info: $0, boxOffice: boxOfficeItem) }
        }
        
    }
    
    func setSearchResultsToViewMovieList(queryValue: String) -> Observable<[String]> {
        return APIService.fetchSearchResultListRx(queryValue: queryValue)
            .map { $0.map { $0.title?.removeBlank() ?? "" } }
    }
    
    
    
    
    
}

