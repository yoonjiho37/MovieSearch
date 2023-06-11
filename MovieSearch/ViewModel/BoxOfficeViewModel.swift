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
    func getErrorMassage() -> Observable<NSError>
}

class BoxOfficeViewModel: BoxOfficeViewModelType {
    let dispaseBag = DisposeBag()
    
    let fetchableList: AnyObserver<BoxOfficeType>
    let nowPageObserver: AnyObserver<Int>
    let tapButtonObserver: AnyObserver<Void>
   
    
    let allListObservable: Observable<[ViewMovieItems]>
    var pageItemObservable: Observable<[ViewMovieItems]>
    var infoViewItemObservable: Observable<[ViewMovieItems]>
    var errorMassageOvervable: Observable<NSError>
    
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
    func getErrorMassage() -> Observable<NSError> {
        return errorMassageOvervable
    }
    
    init(dao: DAOType = DAO(), domain: DomainType = Domain()) {
        let fetchingSubject = PublishSubject<BoxOfficeType>()
        let listSubject = BehaviorSubject<[ViewMovieItems]>(value: [])
        let setViewRankListSubject = PublishSubject<ViewRankList>()
        
        let tapButtonSubject = PublishSubject<Void>()
        let pageSubject = PublishSubject<Int>()
        let pagingSubject = PublishSubject<[ViewMovieItems]>()
        let errorSubject = PublishSubject<Error>()
        

        //input
        self.fetchableList = fetchingSubject.asObserver()
        fetchingSubject
            .flatMap { type -> Observable<ViewRankList> in
                if NetworkCheck.shared.checkConneted() {
                    return domain.checkBoxOfficeWeely(type: type)
                } else {
                    return dao.setRankList(listype: type)
                }
            }
            .subscribe(onNext: setViewRankListSubject.onNext(_:),
                       onError: errorSubject.onNext(_:))
            .disposed(by: dispaseBag)


        setViewRankListSubject
            .map { list in
                return list.viewMovieList
            }
            .subscribe(onNext: listSubject.onNext(_:))
            .disposed(by: dispaseBag)
        
        setViewRankListSubject
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { rankList in
                if NetworkCheck.shared.checkConneted() {
                    CoreDataManager.shared.coverUpRankList(data: rankList)
                }
            }
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
        self.errorMassageOvervable = errorSubject.map { $0 as NSError}
    }
}
