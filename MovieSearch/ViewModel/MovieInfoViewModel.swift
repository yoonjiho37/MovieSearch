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
}

class MovieInfoViewModel: MovieInfoViewModelType {
    let disposeBag = DisposeBag()
    
    let movieInfoObservable: Observable<ViewMovieItems?>
    
    func getMovieInfo() -> Observable<ViewMovieItems?> {
        return movieInfoObservable
    }
    
    init(_ selectedMovie: [ViewMovieItems]? = []) {
        let movieSubject = Observable.just(selectedMovie)
            .map { $0!.first }
            .debug()
        
        self.movieInfoObservable = movieSubject
    }
    
}
