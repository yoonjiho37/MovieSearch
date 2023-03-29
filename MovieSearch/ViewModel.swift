//
//  ViewModel.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/03/22.
//

import Foundation
import RxSwift

protocol RankViewModelType {
    var allList: Observable<[ViewList]> { get }
    
    func fetchList()
}

class RankViewModel: RankViewModelType {
    let dispaseBag = DisposeBag()
    
    let fetchableList: AnyObserver<Void>
    let allList: Observable<[ViewList]>
    
    func fetchList() {
        fetchableList.onNext(())
    }
    
    init(domain: DomainType = Domain()) {
        let fetching = PublishSubject<Void>()
        let list = BehaviorSubject<[ViewList]>(value: [])
        
        //input
        self.fetchableList = fetching.asObserver()
        
        fetching
            .do(onNext: { print("viewModel ==>>") })
            .flatMap(domain.setViewList)
            .do(onError: { Error in
                print("error in fetching")
            })
            .subscribe(onNext: list.onNext)
            .disposed(by: dispaseBag)
        
        
        //output
        self.allList = list
    }
}
