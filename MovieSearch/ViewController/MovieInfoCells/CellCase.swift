//
//  CellCase.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/05/03.
//

import Foundation

enum CellCase {
    case info(ViewMovieItems)
    case buttons(ViewMovieItems)
    case gallery(ViewMovieItems)
    case plot(ViewMovieItems)
    case cast(ViewMovieItems)
}
