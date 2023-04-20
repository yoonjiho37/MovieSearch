//
//  ViewModel.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/03/22.
//

import Foundation
import RxSwift


protocol BoxOfficeViewModelType {
    func fetchList(type: BoxOfficeType)
    func getAllList() -> Observable<[ViewMovieItems]>
    func getNowPage(page: Int)
    func getPageData() -> Observable<[ViewMovieItems]>
}

class BoxOfficeViewModel: BoxOfficeViewModelType {
    let dispaseBag = DisposeBag()
    
    let fetchableList: AnyObserver<BoxOfficeType>
    let allListObservable: Observable<[ViewMovieItems]>
    let nowPageObserver: AnyObserver<Int>
    var pageItemObservable: Observable<[ViewMovieItems]>
    
    
    
    
    
    func fetchList(type: BoxOfficeType) {
        fetchableList.onNext(type)
    }
    func getAllList() -> Observable<[ViewMovieItems]> {
        return allListObservable
    }
    func getNowPage(page: Int){
        nowPageObserver.on(.next(page))
    }
    func getPageData() -> Observable<[ViewMovieItems]> {
        return pageItemObservable
    }

    
    init(domain: DomainType = Domain()) {
        let fetchingSubject = PublishSubject<BoxOfficeType>()
        let listSubject = BehaviorSubject<[ViewMovieItems]>(value: [])
        
        let pageSubject = PublishSubject<Int>()
        let pagingSubject = PublishSubject<[ViewMovieItems]>()
        
        //input
        self.fetchableList = fetchingSubject.asObserver()
        fetchingSubject
            .flatMap { type -> Observable<[ViewMovieItems]> in
                return domain.checkBoxOfficeWeely(type: type)
            }
            .subscribe(onNext: listSubject.onNext(_:))
            .disposed(by: dispaseBag)
        
        
        self.nowPageObserver = pageSubject.asObserver()
        pageSubject
            .flatMap({ num -> Observable<[ViewMovieItems]> in
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
