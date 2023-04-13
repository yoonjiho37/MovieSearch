//
//  Domain.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/03/23.
//

import Foundation
import RxSwift

protocol DomainType {
    //    func fetchItems(fetc1: FetchFor, fetc2: String) -> Observable<[ViewMovieList]>
    func setSearchResult() -> Observable<[ViewMovieList]>
}
enum FetchFor {
    case search
    case boxofficeList
}

class Domain: DomainType {
    let disposeBag = DisposeBag()
    
    var currentDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: Date())
    }
    
    
//    func fetchItems(fetc1: FetchFor, fetc2: String) -> Observable<[ViewMovieList]> {
//        switch fetc1 {
//        case .search:
//            return setViewList(queryValue: fetc2)
//        case .boxofficeList:
//            return setViewList(queryValue: fetc2)
//        }
//    }
    func setSearchResult() -> Observable<[ViewMovieList]> {
        let observableList = setBoxOfficeList().flatMap { boxOfficeList -> Observable<[ViewMovieList]> in
            let obs = boxOfficeList.map { APIService.fetchSearchResultRx(queryValue: $0.movieNm)
                .map {ViewMovieList(info: $0) } }
            return Observable.combineLatest(obs)
        }
        return observableList
    }
    
    func setBoxOfficeList() -> Observable<[BoxOfficeItems]> {
        return APIService.fetchBoxOfficeRx().map { $0.dailyBoxOfficeList.map { $0 } }
        
    }
    
    
  
}

