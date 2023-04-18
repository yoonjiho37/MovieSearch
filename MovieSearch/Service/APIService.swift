//
//  Repository.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/03/22.
//

import Foundation
import RxSwift



class APIService {
    enum dataForm {
        case boxOfficeResult
        case searchResult
    }
    
    //MARK: Fetch - BoxOffice
    static var boxOfficeMainURL: String = "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?"
    static var boxOfficeKey: String = "8c7c736bd850cfc9c87b1245a20cf7e6"
   
    static func fetchBoxOffice(onComplete: @escaping (Result<BoxOfficeResult, Error>) -> Void) {
        let urlString = boxOfficeMainURL + "key=\(boxOfficeKey)" + "&targetDt=\(Date().getYesterday())"
        guard let url: URL = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, res, err in
            if let err = err {
                onComplete(.failure(err))
                return
            }
            guard let data = data else {
                let httpResponse = res as! HTTPURLResponse
                onComplete(.failure(NSError(domain: "no data",
                                            code: httpResponse.statusCode)))
                return
            }
            decodeJsonData(onComplete: onComplete, decodeForm: .boxOfficeResult, data: data)
        }.resume()
    }
    
    //MARK: Fetch - Search Result
    static let movieInfoMainURL: String = "https://api.koreafilm.or.kr/openapi-data2/wisenut/search_api/search_json2.jsp?"
    static let ServiceKey: String = "NDXS32QV526UF7FU68G4"
    
    static func fetchMovie(queryValue: String ,onComplete: @escaping (Result<MovieInfo,Error>) -> Void) {
        let queryurl: String = "\(movieInfoMainURL)collection=kmdb_new2&detail=Y&listCount=1&query=\(queryValue)&ServiceKey=\(ServiceKey)"
        let encodedStr = queryurl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let url = URL(string: encodedStr) else { return }
        URLSession.shared.dataTask(with: url) { data, res, err in
            if let err = err {
                onComplete(.failure(err))
                return
            }
            guard let data = data else {
                let httpResponse = res as! HTTPURLResponse
                onComplete(.failure(NSError(domain: "no data",
                                            code: httpResponse.statusCode)))
                return
            }
            decodeJsonData(onComplete: onComplete, decodeForm: .searchResult, data: data)
        }.resume()
    }
    
    //MARK: Send Fetched Results Rx
    static func fetchSearchResultRx(queryValue: String) -> Observable<MovieInfo> {
        return Observable.create({ emitter in
            fetchMovie(queryValue: queryValue) { result in
                switch result {
                case let .success(data):
                    emitter.onNext(data)
                    emitter.onCompleted()
                case let .failure(err):
                    emitter.onError(err)
                }
            }
            return Disposables.create()
        })
    }
    
    static func fetchBoxOfficeRx() -> Observable<BoxOfficeResult> {
        return Observable.create({ emitter in
            fetchBoxOffice() {result in
                switch result {
                case let .success(data):
                    emitter.onNext(data)
                    emitter.onCompleted()
                case let .failure(err):
                    emitter.onError(err)
                }
            }
            return Disposables.create()
        })
    }

    
    //MARK: JsonDecoder
    static func decodeJsonData<T>(onComplete: @escaping (Result<T, Error>) -> Void, decodeForm: dataForm, data: Data) {
        do {
            switch decodeForm {
            case .boxOfficeResult:
                let response = try JSONDecoder().decode(BoxOffice.self, from: data)
                return onComplete(.success(response.boxOfficeResult as! T))
            case .searchResult:
                let response = try JSONDecoder().decode(SearchChannel.self, from: data)
                return onComplete(.success(response.Data[0].Result[0] as! T))
            }
        }catch{
            return onComplete(.failure(NSError(domain: "Decoding Error", code: -1)))
        }
    }
}


