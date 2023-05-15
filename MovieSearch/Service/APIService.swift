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
  
     
    static func getBoxOfficeURL(_ type: BoxOfficeType) -> URL {
        let boxOfficeMainURL = "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/"
        let boxOfficeKey = "key=8c7c736bd850cfc9c87b1245a20cf7e6"
        let dailyType = "searchDailyBoxOfficeList.json?"
        let weeklyType = "searchWeeklyBoxOfficeList.json?"
        let targetDt = "&targetDt=\(Date().getYesterday())"
        let targetDtLastSunday = "&targetDt=\(Date().getLastSunday())"
        var urlStr = ""
        switch type {
        case .daily:
            urlStr = boxOfficeMainURL + dailyType + boxOfficeKey + targetDt
        case .weekly:
            urlStr = boxOfficeMainURL + weeklyType + boxOfficeKey + targetDtLastSunday + "&weekGb=0"
        case .weekEnd:
            urlStr = boxOfficeMainURL + weeklyType + boxOfficeKey + targetDtLastSunday + "&weekGb=1"
        }
        print("url ==> \(urlStr)")
        guard let url = URL(string: urlStr) else { return URL(string: "")!}
        return url
    }
    
    static func fetchBoxOffice(onComplete: @escaping (Result<BoxOfficeResult, Error>) -> Void) {
        URLSession.shared.dataTask(with: getBoxOfficeURL(.daily)) { data, res, err in
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
            decodeJsonData(onComplete: onComplete, decodeForm: .boxOfficeResult,type: .daily, data: data)
        }.resume()
    }
    
    static func fetchBoxOfficeWeely(type: BoxOfficeType ,onComplete: @escaping (Result<BoxOfficeWeeklyReult, Error>) -> Void) {
        URLSession.shared.dataTask(with: getBoxOfficeURL(type)) { data, res, err in
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
            decodeJsonData(onComplete: onComplete, decodeForm: .boxOfficeResult,type: type, data: data)
        }.resume()
    }
    
    //MARK: Fetch - Search Result
    static let movieInfoMainURL: String = "https://api.koreafilm.or.kr/openapi-data2/wisenut/search_api/search_json2.jsp?"
    static let ServiceKey: String = "NDXS32QV526UF7FU68G4"
    
    static func fetchMovie(queryValue: String ,onComplete: @escaping (Result<MovieInfo,Error>) -> Void) {
        let queryurl: String = "\(movieInfoMainURL)collection=kmdb_new2&detail=Y&listCount=1&query=\(queryValue)&ServiceKey=\(ServiceKey)"
        print("url2 => \(queryurl)")
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
            decodeJsonData(onComplete: onComplete, decodeForm: .searchResult,type: nil, data: data)
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
            fetchBoxOffice() { result in
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
    
    static func fetchBoxOfficeWeelyRx(type: BoxOfficeType) -> Observable<BoxOfficeWeeklyReult> {
        return Observable.create({ emitter in
            fetchBoxOfficeWeely(type: type) { result in
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
    static func decodeJsonData<T>(onComplete: @escaping (Result<T, Error>) -> Void, decodeForm: dataForm, type: BoxOfficeType?, data: Data) {
        do {
            switch decodeForm {
            case .boxOfficeResult:
                switch type {
                case .daily:
                    let response = try JSONDecoder().decode(BoxOffice.self, from: data)
                    return onComplete(.success(response.boxOfficeResult as! T))
                case .weekly, .weekEnd:
                    let response = try JSONDecoder().decode(BoxOfficeWeekly.self, from: data)
                    return onComplete(.success(response.boxOfficeResult as! T))
                case .none: break
                }
                
            case .searchResult:
                let response = try JSONDecoder().decode(SearchChannel.self, from: data)
                return onComplete(.success(response.Data[0].Result[0] as! T))
            }
        } catch {
            return onComplete(.failure(NSError(domain: "Decoding Error", code: -1)))
        }
    }
}


