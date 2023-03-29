//
//  Domain.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/03/23.
//

import Foundation
import RxSwift

protocol DomainType {
    func setViewList() -> Observable<[ViewList]>
}

class Domain: DomainType {
    func setViewList() -> Observable<[ViewList]> {
        print("domain ==>>")
        return APIService.fetchBoxOfficeRx()
            .map { $0.dailyBoxOfficeList.map { ViewList($0) } }
    }
}
