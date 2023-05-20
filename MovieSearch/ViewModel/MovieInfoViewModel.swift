//
//  MovieInfoViewModel.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/04/18.
//

import Foundation
import RxSwift

protocol MovieInfoViewModelType {
    func getMovieInfo() -> Observable<ViewMovieItems?>
    
    func getUpdateEvent(type: UpdateType)
    func getUpdateResult() -> Observable<ViewMovieItems>

}

class MovieInfoViewModel: MovieInfoViewModelType {
    let disposeBag = DisposeBag()
    
    let movieInfoObservable: Observable<ViewMovieItems?>
    
    let updateObserver: AnyObserver<UpdateType>
    let updateResultObserver: Observable<ViewMovieItems>
    
    func getMovieInfo() -> Observable<ViewMovieItems?> {
        return movieInfoObservable
    }
    func getUpdateEvent(type: UpdateType) {
        updateObserver.on(.next(type))
    }
    func getUpdateResult() -> Observable<ViewMovieItems> {
        return updateResultObserver
    }
    
    
    
    init(dao: DAOType = DAO(),_ selectedMovie: [ViewMovieItems]? = []) {
        let updatePublish = PublishSubject<UpdateType>()
        let updateResult = PublishSubject<ViewMovieItems>()
        
        let movieSubject = Observable.just(selectedMovie)
            
        self.movieInfoObservable = movieSubject
            .map { $0!.first }
        
        
        updateObserver = updatePublish.asObserver()
        updatePublish
            .flatMap { type -> Observable<ViewMovieItems> in
                print("vm type ---")
                return dao.updateItem(type: type, movie: selectedMovie![0])
                    .map { $0.first! }
            }
            .subscribe(onNext: updateResult.onNext(_:))
            .disposed(by: disposeBag)
            
        
        self.updateResultObserver = updateResult.debug("info ---")
        
       
    }
    
}
