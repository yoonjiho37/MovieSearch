//
//  Domain.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/03/23.
//

import Foundation
import RxSwift

protocol DomainType {
    func setBoxOfficeListToViewMovieList() -> Observable<[ViewMovieList]>
}
enum FetchFor {
    case search
    case boxofficeList
}

class Domain: DomainType {
    let disposeBag = DisposeBag()
        
    func setBoxOfficeListToViewMovieList() -> Observable<[ViewMovieList]> {
        let observableList = APIService.fetchBoxOfficeRx().flatMap { it -> Observable<[ViewMovieList]> in
            let obs = it.dailyBoxOfficeList
                .map { items in
                    self.setSearchResult(queryValue: items.movieNm, rank: items.rank)
                }
            return Observable.combineLatest(obs)
        }
        return observableList
    }
    
    func setSearchResult(queryValue: String, rank: String) -> Observable<ViewMovieList> {
        return APIService.fetchSearchResultRx(queryValue: queryValue).map{ ViewMovieList(info: $0, rank: Int(rank)!)}
    }
}

