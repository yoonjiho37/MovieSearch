//
//  SavedMovieListViewModel.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/05/17.
//

import Foundation
import RxSwift

protocol SavedMovieListViewModelType {
    func getMovieList() -> Observable<[ViewMovieItems]>
}

enum ListType {
    case liked
    case watchLater
}

class SavedMovieListViewModel: SavedMovieListViewModelType {
    let disposeBag = DisposeBag()
    
    let movieInfoObservable: Observable<[ViewMovieItems]>
    
    func getMovieList() -> Observable<[ViewMovieItems]> {
        return movieInfoObservable
    }
    
    init(dao: DAOType = DAO(), listType: ListType?) {
        
        let listTypeObsJust = Observable<ListType>.just(listType!)
        let movieInfoPublish = PublishSubject<[ViewMovieItems]>()

        var listTypePublish = PublishSubject<ListType>()
        
        
        listTypePublish = listTypeObsJust as! PublishSubject<ListType>
        
        listTypePublish.asObserver()
            .flatMap { type -> Observable<[ViewMovieItems]> in
                switch type {
                case .liked:
                    return dao.fetchCoreData(type: .fetchList, id: nil)
                case .watchLater:
                    return dao.fetchCoreData(type: .fetchList, id: nil)
                }
            }
            .subscribe(onNext: movieInfoPublish.onNext(_:))
            .disposed(by: disposeBag)
        
        self.movieInfoObservable = movieInfoPublish
        
    }
}
