//
//  Domain.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/03/23.
//

import Foundation
import RxSwift

protocol DomainType {
    func checkBoxOfficeWeely(type: BoxOfficeType) -> Observable<[ViewMovieItems]>
}
enum FetchFor {
    case search
    case boxofficeList
}


class Domain: DomainType {
    let disposeBag = DisposeBag()
    var dailyObserbale: Observable<[ViewMovieItems]>
    var weeklyObservable: Observable<[ViewMovieItems]>
    var weekEndObservable: Observable<[ViewMovieItems]>
    
    
    func checkBoxOfficeWeely(type: BoxOfficeType) -> Observable<[ViewMovieItems]> {
        switch type {
        case .daily:
            return setBoxOfficeList()
        case .weekly, .weekEnd:
            return setBoxOfficeListWeely(type: type)
        }
    }
    
    func setBoxOfficeList() -> Observable<[ViewMovieItems]> {
        let observableList = APIService.fetchBoxOfficeRx().flatMap { result -> Observable<[ViewMovieItems]> in
            let obs = result.dailyBoxOfficeList
                .map { items in
                    self.setSearchResult(queryValue: items.movieNm, rank: items.rank)
                }
            return Observable.combineLatest(obs)
        }
        return observableList
    }
    
    func setBoxOfficeListWeely(type: BoxOfficeType) -> Observable<[ViewMovieItems]> {
        let observableList = APIService.fetchBoxOfficeWeelyRx(type: type).flatMap { result -> Observable<[ViewMovieItems]> in
            let obs = result.weeklyBoxOfficeList
                .map { items in
                    self.setSearchResult(queryValue: items.movieNm, rank: items.rank)
                }
            return Observable.combineLatest(obs)
        }
        return observableList
    }
    
    func setSearchResult(queryValue: String, rank: String) -> Observable<ViewMovieItems> {
        return APIService.fetchSearchResultRx(queryValue: queryValue.removeChactors())
            .map { ViewMovieItems(info: $0, rank: Int(rank)!)}
    }
    
    init() {
        let daily = PublishSubject<[ViewMovieItems]>()
        let weekly = PublishSubject<[ViewMovieItems]>()
        let weekEnd = PublishSubject<[ViewMovieItems]>()
        
        self.dailyObserbale = daily.asObserver()
        self.weeklyObservable = weekly.asObserver()
        self.weekEndObservable = weekEnd.asObserver()
    }
}

