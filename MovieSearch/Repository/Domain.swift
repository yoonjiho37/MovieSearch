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
                        self.setSearchResultToViewMovieList(boxOfficeItem: items)
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
                        self.setSearchResultToViewMovieList(boxOfficeItem: items)
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
    
    private func setSearchResultToViewMovieList(boxOfficeItem: BoxOfficeItems) -> Observable<ViewMovieItems> {
        return APIService.fetchSearchResultRx(queryValue: boxOfficeItem.movieNm.removeBlank().removeChactors() )
            .map { ViewMovieItems(info: $0, boxOffice: boxOfficeItem) }
    }
}

