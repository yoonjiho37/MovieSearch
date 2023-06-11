//
//  SearchBarViewModel.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/06/08.
//

import Foundation
import RxSwift

protocol SearchBarViewModelType {
    func getInputedText(text: String)
    func getsearchResult() -> Observable<[String]>
    func getErrorMessage() -> Observable<NSError>
    
    func getInfoItem() -> Observable<ViewMovieItems>
    func getSelectEvent(index: Int)
}

class SearchBarViewModel: SearchBarViewModelType {
    let disposeBag = DisposeBag()
    
    var searchResultObservable: Observable<[String]>
    var inputedTextObserver: AnyObserver<String>
    
    var selectEventObserver: AnyObserver<Int>
    var infoObservable: Observable<ViewMovieItems>
    var errorObservable: Observable<NSError>
     
    
    
    func getsearchResult() -> Observable<[String]> {
        return searchResultObservable
    }
    func getInputedText(text: String) {
        inputedTextObserver.on(.next(text))
    }
    func getInfoItem() -> Observable<ViewMovieItems> {
        return infoObservable
    }
    func getSelectEvent(index: Int) {
        selectEventObserver.on(.next(index))
    }
    func getErrorMessage() -> Observable<NSError> {
        return errorObservable
    }
    
    init(domain: DomainType = Domain(), dao: DAOType = DAO()) {
        let inputEventSubject = PublishSubject<String>()
        let resultSubject = PublishSubject<[String]>()
        
        let selectEventSubject = PublishSubject<Int>()
        let searchQuerySubject = PublishSubject<String>()
        let movieInfoSubject = PublishSubject<ViewMovieItems>()
        
        let errorSubject = PublishSubject<Error>()
        
        self.inputedTextObserver = inputEventSubject.asObserver()
        inputEventSubject
            .flatMap { query -> Observable<[String]> in
                return domain.setSearchResultsToViewMovieList(queryValue: query)
            }
            .subscribe(onNext: resultSubject.onNext(_:),
                       onError: errorSubject.onNext(_:))
            .disposed(by: disposeBag)
        
        self.searchResultObservable = resultSubject
        
        
        self.selectEventObserver = selectEventSubject.asObserver()
        
        selectEventSubject.withLatestFrom(resultSubject) { idx, result -> String in
            let item = result[idx]
            return item
        }
        .flatMap { query -> Observable<ViewMovieItems> in
            return domain.setSearchResultToViewMovieList(query, nil)
        }
        .subscribe(onNext: movieInfoSubject.onNext(_:))
        .disposed(by: disposeBag)
        
            
          
        
        searchQuerySubject.asObserver().debug("query ]]")
            .flatMap { query -> Observable<ViewMovieItems> in
                print("VM2 ]] \(query)")
                return domain.setSearchResultToViewMovieList(query, nil)
            }
            .subscribe(onNext: movieInfoSubject.onNext(_:))
            .disposed(by: disposeBag)
        
        self.infoObservable = movieInfoSubject
            
        
        self.errorObservable = errorSubject.map { $0 as NSError}
    }
}
