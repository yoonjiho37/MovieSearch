//
//  Repository.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/03/22.
//

import Foundation
import RxSwift



class APIService {
    static var boxOfficeURL: String = "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=8c7c736bd850cfc9c87b1245a20cf7e6&targetDt=20230301"
    
    static let url: URL? = URL(string: boxOfficeURL)
    
    static func fetchBoxOfficeRx() -> Observable<BoxOfficeResult> {
        return Observable.create({ emitter in
            fetchBoxOffice() {result in
                switch result {
                case let .success(data):
                    print("repository ==>>")
                    emitter.onNext(data)
                    emitter.onCompleted()
                case let .failure(err):
                    emitter.onError(err)
                    print("repository ==>> false")
                }
            }
            return Disposables.create()
        })
    }
    
    static func fetchBoxOffice(onComplete: @escaping (Result<BoxOfficeResult, Error>) -> Void) {
        guard let u = url else { print("url is nil"); return }
        URLSession.shared.dataTask(with: u) { data, res, err in
            print("fetchRx2-2")

            if let err = err {
                onComplete(.failure(err))
                print("fetchRx2 err fail")
                return
            }
            guard let data = data else {
                let httpResponse = res as! HTTPURLResponse
                onComplete(.failure(NSError(domain: "no data",
                                            code: httpResponse.statusCode)))
                print("fetchRx2 data fail")
                return }
            

            decodeJsonData(onComplete: onComplete, data: data)
        }.resume()
    }
    
    static func decodeJsonData(onComplete: @escaping (Result<BoxOfficeResult, Error>) -> Void, data: Data) {
        do {
            let response = try JSONDecoder().decode(BoxOffice.self, from: data)
            print("fetch res ==>> \(response.boxOfficeResult.boxofficeType)")
            return onComplete(.success(response.boxOfficeResult))
        }catch{
            return onComplete(.failure(NSError(domain: "Decoding Error", code: -1)))
        }
    }
}
