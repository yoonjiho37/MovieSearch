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
}

class BoxOfficeViewModel: RankViewModelType {
    let dispaseBag = DisposeBag()
    var nowPage: Int = 0
    
    let fetchableList: AnyObserver<Void>
    let allList: Observable<[ViewMovieList]>
    
    func fetchList() -> AnyObserver<Void> {
        fetchableList
    }
    
    
    init(domain: DomainType = Domain()) {
        let fetching = PublishSubject<Void>()
        let list = BehaviorSubject<[ViewMovieList]>(value: [])
        
        self.fetchableList = fetching.asObserver()
        

        //input
        fetching
            .flatMap { viewList -> Observable<[ViewMovieList]> in
                return domain.setSearchResult()
            }
            .subscribe(onNext: list.onNext(_:))
            .disposed(by: dispaseBag)
        
        
        //output
        self.allList = list
        
        
    }
}
