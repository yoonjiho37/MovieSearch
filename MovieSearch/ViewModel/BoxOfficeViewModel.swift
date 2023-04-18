//
//  ViewModel.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/03/22.
//

import Foundation
import RxSwift


protocol RankViewModelType {
    func fetchList() -> AnyObserver<Void>
    func getAllList() -> Observable<[ViewMovieList]>
    func getNowPage(page: Int)
    func getPageData() -> Observable<[ViewMovieList]>
}

class BoxOfficeViewModel: RankViewModelType {
    let dispaseBag = DisposeBag()
    
    let fetchableList: AnyObserver<Void>
    let allListObservable: Observable<[ViewMovieList]>
    let nowPageObserver: AnyObserver<Int>
    var pageItemObservable: Observable<[ViewMovieList]>
    
    
    
    func getAllList() -> Observable<[ViewMovieList]> {
        return allListObservable
    }
    
    func fetchList() -> AnyObserver<Void> {
        return fetchableList
    }
    
    func getNowPage(page: Int){
        return nowPageObserver.on(.next(page))
    }
    
    func getPageData() -> Observable<[ViewMovieList]> {
        return pageItemObservable
    }

    
    init(domain: DomainType = Domain()) {
        let fetchingSubject = PublishSubject<Void>()
        let listSubject = BehaviorSubject<[ViewMovieList]>(value: [])
        
        let pageSubject = PublishSubject<Int>()
        let pagingSubject = PublishSubject<[ViewMovieList]>()
        
        //input
        self.fetchableList = fetchingSubject.asObserver()
        fetchingSubject
            .debug("fetching ==>>")
            .flatMap { viewList -> Observable<[ViewMovieList]> in
                return domain.setBoxOfficeListToViewMovieList()
            }
            .subscribe(onNext: listSubject.onNext(_:))
            .disposed(by: dispaseBag)
        
        
        self.nowPageObserver = pageSubject.asObserver()
        pageSubject
            .flatMap({ num -> Observable<[ViewMovieList]> in
                let item = listSubject.element(at: 0).map { $0.filter{ $0.rank == num + 1} }
                return item.element(at: 0)
            })
            .subscribe(onNext: pagingSubject.onNext(_:))
            .disposed(by: dispaseBag)
        
        
        //output
        self.allListObservable = listSubject
        
        self.pageItemObservable = pagingSubject
    }
}
