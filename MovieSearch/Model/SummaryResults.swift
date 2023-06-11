//
//  SummaryResults.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/06/09.
//

import Foundation



struct SummaryResult: Codable {
    let Query: String
    let KMAQuery: String
    let TotalCount: Int
    let Data: [SummaryResultList]
}
struct SummaryResultList: Codable {
    let CollName: String
    let TotalCount: Int
    let Count: Int
    let Result: [SummaryItems]
}

struct SummaryItems: Codable {
    let DOCID: String?
    let movieId: String?
    let movieSeq: String?
    let title: String?
    let titleEng: String?
    let titleOrg: String?
    let titleEtc: String?
    let prodYear: String?
    let directors: Directors?
    let actors: Actors?
    let nation: String?
    let company: String?
    let plots: Plots?
    let runtime: String?
    let rating: String?
    let genre: String?
    let kmdbUrl: String?
}

