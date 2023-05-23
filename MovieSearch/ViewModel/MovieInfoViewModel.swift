//
//  MovieInfoViewModel.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/04/18.
//

import Foundation
import RxSwift

protocol MovieInfoViewModelType {
    func getMovieInfo() -> Observable<ViewMovieItems>
    func getAppearEvent()
    
    func getUpdateEvent(type: UpdateType)
    func getUpdateResult() -> Observable<ViewMovieItems>

}

class MovieInfoViewModel: MovieInfoViewModelType {
    let disposeBag = DisposeBag()
    
    let getAppearEventObserver: AnyObserver<Void>
    let movieInfoObservable: Observable<ViewMovieItems>
    
    let updateObserver: AnyObserver<UpdateType>
    let updateResultObserver: Observable<ViewMovieItems>
    
    func getAppearEvent() {
        getAppearEventObserver.on(.next(()))
    }
    func getMovieInfo() -> Observable<ViewMovieItems> {
        return movieInfoObservable
    }
    func getUpdateEvent(type: UpdateType) {
        updateObserver.on(.next(type))
    }
    func getUpdateResult() -> Observable<ViewMovieItems> {
        return updateResultObserver
    }
    
    
    
    init(dao: DAOType = DAO(),_ selectedMovie: [ViewMovieItems]? = []) {
        let viewAppearSubject = PublishSubject<Void>()
        let movieSubject = PublishSubject<ViewMovieItems>()
        
        let updateSubject = PublishSubject<UpdateType>()
        let updateResult = PublishSubject<ViewMovieItems>()
        
        
        self.getAppearEventObserver = viewAppearSubject.asObserver()
        
        viewAppearSubject
            .flatMap { event -> Observable<ViewMovieItems> in
                guard let selectedMovie = selectedMovie?.first else { return Observable.merge([]) }
                let movieCode = selectedMovie.movieCode
                let fetchedMovie = dao.fetchCoreData(type: .fetchItem, code: movieCode, listType: nil)
                    .flatMap { list -> Observable<ViewMovieItems> in
                        if list.isEmpty {
                            return Observable.just(selectedMovie)
                        } else {
                            let item = list.first!
                            return Observable.just(item)
                        }
                    }
                return fetchedMovie
            }
            .subscribe(onNext: movieSubject.onNext(_:))
            .disposed(by: disposeBag)
        
        
        self.movieInfoObservable = movieSubject

        
        updateObserver = updateSubject.asObserver()
        updateSubject
            .flatMap { type -> Observable<ViewMovieItems> in
                return dao.updateItem(type: type, movie: selectedMovie![0])
                    .map { $0.first! }
            }
            .subscribe(onNext: updateResult.onNext(_:))
            .disposed(by: disposeBag)
            
        
        self.updateResultObserver = updateResult
        
       
    }
    
}
