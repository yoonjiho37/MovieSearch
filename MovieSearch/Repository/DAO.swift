//
//  DAO.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/05/11.
//

import Foundation
import RxSwift
import CoreData

protocol DAOType {
    func fetchCoreData(type: FetchCoreData, code: String?, listType: ListType?) -> Observable<[ViewMovieItems]>
    func updateItem(type: UpdateType, movie: ViewMovieItems) -> Observable<[ViewMovieItems]>
    func setRankList(listype: BoxOfficeType) -> Observable<ViewRankList>
    func coverUpRankList(list: ViewRankList)
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
    
    func fetchCoreData(type: FetchCoreData, code: String?, listType: ListType?) -> Observable<[ViewMovieItems]> {
        switch type {
        case .fetchList:
            return setList(type: listType)
        case .fetchItem:
            return setItem(code: code)
        }
    }
        
    func updateItem(type: UpdateType, movie: ViewMovieItems) -> Observable<[ViewMovieItems]> {
        return CoreDataManager.shared.updateData(type: type, movie: movie)
            .flatMap { reult -> Observable<[ViewMovieItems]> in
                if reult {
                    return self.fetchCoreData(type: .fetchItem, code: movie.movieCode, listType: nil)
                } else {
                    return Observable.just([])
                }
            }
    }
    
    private func setList(type: ListType?) -> Observable<[ViewMovieItems]> {
        return CoreDataManager.shared.fetchLocalListRX()
            .map { $0.map { ViewMovieItems(localInfo: $0) } }
            .map { list in
                guard let type = type else { return list}
                switch type {
                case .liked:
                    return list.filter { $0.likeBoolean == true }
                case .watchLater:
                    return list.filter { $0.watchLaterBoolean == true}
                }
            }
    }
    
    private func setItem(code: String?) -> Observable<[ViewMovieItems]> {
        return CoreDataManager.shared.fetchLocalListRX()
            .map { $0.map { ViewMovieItems(localInfo: $0 ) } }
            .map { $0.filter { $0.movieCode == code } }
    }
     
}


extension DAO {
    func setRankList(listype: BoxOfficeType) -> Observable<ViewRankList> {
        return CoreDataManager.shared.fetchLocalRankListRX(listType: listype)
            .map { ViewRankList(localList: $0) }
    }

    func coverUpRankList(list: ViewRankList) {
        CoreDataManager.shared.coverUpRankList(data: list)
    }
}
