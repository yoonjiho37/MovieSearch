//
//  DAO.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/05/11.
//

import Foundation
import RxSwift

protocol DAOType {
    func fetchCoreData(type: FetchCoreData, id: String?) -> Observable<[ViewMovieItems]>
    func updateItem(type: UpdateType, movie: ViewMovieItems) -> Observable<[ViewMovieItems]>
}

enum FetchCoreData {
    case fetchList
    case fetchItem
}

enum UpdateType {
    case like
    case watchLater
}


class DAO: DAOType {
    
    var boollll: Bool = true {
        didSet {
            print("4 didset --> \(boollll)")
        }
    }
    
    func fetchCoreData(type: FetchCoreData, id: String?) -> Observable<[ViewMovieItems]> {
        switch type {
        case .fetchList:
            return setList()
        case .fetchItem:
            return setItem(id: id)
        }
    }
        
    func updateItem(type: UpdateType, movie: ViewMovieItems) -> Observable<[ViewMovieItems]> {
        return CoreDataManager.shared.updateData(type: type, movie: movie)
            .flatMap { reult -> Observable<[ViewMovieItems]> in
                if reult {
                    return self.fetchCoreData(type: .fetchItem, id: movie.movieId)
                } else {
                    return Observable.just([])
                }
            }
    }
    
    
    
    private func setList() -> Observable<[ViewMovieItems]> {
        return CoreDataManager.shared.fetchLocalListRX(id: nil)
            .map { $0.map { ViewMovieItems(localInfo: $0) } }
    }
    
    private func setItem(id: String?) -> Observable<[ViewMovieItems]> {
        return CoreDataManager.shared.fetchLocalListRX(id: id)
            .map { $0.map { ViewMovieItems(localInfo: $0 ) } }
    }
    
   
   
}



//_ = obs.element(at: 0).map { $0[0].likeBoolean }
//                        .subscribe(onNext: { self.boollll = $0 })
//                    print("4 -->> \(self.boollll)")
