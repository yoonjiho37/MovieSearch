//
//  MovieInfoViewModel.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/04/18.
//

import Foundation
import RxSwift

protocol MovieInfoViewModelType {
    func getMovieInfo()
}

class MovieInfoViewModel: MovieInfoViewModelType {
    let disposeBag = DisposeBag()
    
    let movieInfoObservable: Observable<[ViewMovieList]>
    func getMovieInfo() {
        
    }
    
    init(_ selectedMovie: [ViewMovieList] = []) {
        let movieSubject = Observable.just(selectedMovie)
        
        self.movieInfoObservable = movieSubject
    }
    
}