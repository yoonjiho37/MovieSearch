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
    func getTapEvent()
    func getInfoView() -> Observable<[ViewMovieItems]>
}

class BoxOfficeViewModel: BoxOfficeViewModelType {
    let dispaseBag = DisposeBag()
    
    let fetchableList: AnyObserver<BoxOfficeType>
    let nowPageObserver: AnyObserver<Int>
    let tapButtonObserver: AnyObserver<Void>
    
    let allListObservable: Observable<[ViewMovieItems]>
    var pageItemObservable: Observable<[ViewMovieItems]>
    var infoViewItemObservable: Observable<[ViewMovieItems]>
    
    
    
    
    func fetchList(type: BoxOfficeType) {
        fetchableList.onNext(type)
    }
    func getAllList() -> Observable<[ViewMovieItems]> {
        return allListObservable
    }
    func getNowPage(page: Int) {
        nowPageObserver.on(.next(page))
    }
    func getPageData() -> Observable<[ViewMovieItems]> {
        return pageItemObservable
    }
    func getTapEvent() {
        tapButtonObserver.on(.next(()))
    }
    func getInfoView() -> Observable<[ViewMovieItems]> {
        return infoViewItemObservable
    }

    
    init(domain: DomainType = Domain()) {
        let fetchingSubject = PublishSubject<BoxOfficeType>()
        let listSubject = BehaviorSubject<[ViewMovieItems]>(value: [])
        let tapButtonSubject = PublishSubject<Void>()
        
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
        
        self.tapButtonObserver = tapButtonSubject.asObserver()
        
        
        //output
        self.allListObservable = listSubject
        self.pageItemObservable = pagingSubject
        self.infoViewItemObservable = tapButtonSubject.withLatestFrom(pagingSubject)
            .map({ item in
                return item
            })
            .debug("asdasdasd")
    }
}
