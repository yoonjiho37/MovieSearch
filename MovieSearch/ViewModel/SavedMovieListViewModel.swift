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
    func getAppearState(type: ListType)
}

enum ListType {
    case liked
    case watchLater
}

class SavedMovieListViewModel: SavedMovieListViewModelType {
    let disposeBag = DisposeBag()
    
    let movieListObservable: Observable<[ViewMovieItems]>
    let appearState: AnyObserver<ListType>
    
    func getMovieList() -> Observable<[ViewMovieItems]> {
        return movieListObservable
    }
    func getAppearState(type: ListType) {
        appearState.on(.next(type))
    }

    
    init(dao: DAOType = DAO()) {
        let movieListPublish = PublishSubject<[ViewMovieItems]>()
        let listTypePublish = PublishSubject<ListType>()
        
        self.movieListObservable = movieListPublish
        self.appearState = listTypePublish.asObserver()
        
        
        listTypePublish
            .flatMap { type -> Observable<[ViewMovieItems]> in
                switch type {
                case .liked:
                    return dao.fetchCoreData(type: .fetchList, title: nil, listType: type)
                case .watchLater:
                    return dao.fetchCoreData(type: .fetchList, title: nil, listType: type)
                }
            }
            .subscribe(onNext: movieListPublish.onNext(_:))
            .disposed(by: disposeBag)
        
        

    }
}


