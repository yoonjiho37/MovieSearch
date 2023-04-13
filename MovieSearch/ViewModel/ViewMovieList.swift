//
//  Domain.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/03/22.
//

import Foundation
import RxSwift

class ViewMovieList {
    let movieId: String  //등록ID    K
    let title: String  //영화명    서편제
//    let directorNm: String  //감독명    김지훈
//    let actors: Actors  //배우명    하지원
    let company: String  //제작사    ㈜JK필름,CJ E&M Pictures
//    let plot: String  //줄거리    제주도 남단, 7광구의.....
    let runtime: String  //대표상영시간    112
    let rating: String  //대표관람등급    15세관람가
    let genre: String  //kmdbUrl    액션,SF
    let posterURL: String
    
    let rank: Int
    
    init(info: MovieInfo) {
        self.movieId = info.movieId
        self.title = info.title.removeBlank()
//        self.directorNm = info.directors.director[0].directorNm
//        self.actors = info.actors
        self.company = info.company
//        self.plot = info.plots.plot[0].plotText
        self.runtime = info.runtime
        self.rating = info.rating
        self.genre = info.genre
        self.posterURL = info.posters
        self.rank = 0
    }
    
    
    init(movieId: String, title: String, company: String, runtime: String, rating: String, genre: String, posterURL: String, rank: Int) {
        self.movieId = movieId
        self.title = title
//        self.directorNm = directorNm
//        self.actors = actors
        self.company = company
//        self.plot = plot
        self.runtime = runtime
        self.rating = rating
        self.genre = genre
        self.posterURL = posterURL
        self.rank = rank
    }
    
    
  
}

extension ViewMovieList: Equatable {
    static func == (lhs: ViewMovieList, rhs: ViewMovieList) -> Bool {
        return lhs.movieId == rhs.movieId && lhs.title == rhs.title && lhs.company == rhs.company && lhs.runtime == rhs.runtime && lhs.rating == rhs.rating && lhs.genre == rhs.genre && lhs.posterURL == rhs.posterURL && lhs.rank == rhs.rank
    }
}
