//
//  ViewModel.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/03/22.
//

import Foundation
import RxSwift

protocol RankViewModelType {
    var allList: Observable<[ViewMovieList]> { get }

    func fetchList() -> AnyObserver<Void>

    func setNowPage() -> AnyObserver<Int>
    func setOutletdatas() -> Observable<[ViewMovieList]>
//    func showInfoPage(_ pageNum: Int) -> Observable<ViewMovieList>

}

class BoxOfficeViewModel: RankViewModelType {
    let dispaseBag = DisposeBag()
    
    let allList: Observable<[ViewMovieList]>
    let fetchableList: AnyObserver<Void>
    
    
    let pageItem: Observable<[ViewMovieList]>
    let nowPage: AnyObserver<Int>

    
    func fetchList() -> AnyObserver<Void> {
        fetchableList
    }
    
    func setNowPage() -> AnyObserver<Int> {
        nowPage
    }
    
    func setOutletdatas() -> Observable<[ViewMovieList]> {
        pageItem
    }
    
//    func showInfoPage(_ pageNum: Int) -> Observable<ViewMovieList> {
////        pageItem
////            .map { $0[pageNum] }
//    }

    
    init(domain: DomainType = Domain()) {
        let fetching = PublishSubject<Void>()
        let list = BehaviorSubject<[ViewMovieList]>(value: [])
        
        let nowPage = PublishSubject<Int>()
        let paging = PublishSubject<[ViewMovieList]>()
        
        //input
        self.fetchableList = fetching.asObserver()
        fetching
            .flatMap { viewList -> Observable<[ViewMovieList]> in
                return domain.setSearchResult()
            }
            .subscribe(onNext: list.onNext(_:))
            .disposed(by: dispaseBag)
        
        
        self.nowPage = nowPage.asObserver()
        nowPage
            .flatMap { pageNum -> Observable<[ViewMovieList]> in
                return list.map { $0.filter { $0.rank == pageNum} }
            }
            .subscribe(onNext: paging.onNext(_:))
            .disposed(by: dispaseBag)
        
        //output
        self.allList = list
        
        self.pageItem = paging
            
        
        
    }
}
