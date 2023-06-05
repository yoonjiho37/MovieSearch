//
//  DBService.swift
//  MovieSearch
//
//  Created by 윤지호 on 2023/05/11.
//

import UIKit
import CoreData
import RxSwift

enum LocalType {
    case LikedList
    case whachLaterList
}

class CoreDataManager {
    static let shared: CoreDataManager = CoreDataManager()
    

    let itemModelName: String = "LikedList"
    let rankListName: String = "RankList"
    let rankItemsName: String = "RankItems"
    
    //MARK: LikedList
    
    func fetchLocalList(onComplete: @escaping (Result<[NSManagedObject?],Error>) -> Void) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: itemModelName)

        do {
            let fetchedData = try context.fetch(fetchRequest)
            if fetchedData.isEmpty {
                onComplete(.success([]))
            } else {
                onComplete(.success(fetchedData))
            }
            
        } catch {
            onComplete(.failure(NSError(domain: "불러오기 실패", code: -1)))
        }
    }
    
    
    func saveMovie(movie: ViewMovieItems) -> NSError? {
        print("save => start")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        guard let itemEntity = NSEntityDescription.entity(forEntityName: itemModelName, in: context) else { return NSError(domain: "", code: -1) }

        let listobject = NSManagedObject(entity: itemEntity, insertInto: context)
        listobject.setValues(viewMovieItems: movie)
        
        do {
            try context.save()
        } catch  {
            return NSError(domain: "save Error", code: -1)
        }
        return nil
    }
    
    func deleteMovie(code: String) -> NSError? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: itemModelName)
        
        do {
            let fetchedData = try context.fetch(fetchRequest)
            let deleteObject = fetchedData.filter { $0.value(forKey: "movieCode") as! String == code }
            
            if deleteObject.isEmpty == false {
                context.delete(deleteObject[0])
            }
            do {
                try context.save()
            } catch let err as NSError {
                fatalError("Unresolved error \(err), \(err.userInfo)")
            }
            
        } catch  {
            return NSError(domain: "save Error", code: -1)
        }
        return nil
    }
    
    
    func updateData(type: UpdateType, movie: ViewMovieItems) -> Observable<Bool> {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: itemModelName)
        
        do {
            let fetchedData = try context.fetch(fetchRequest)

            let objectUpdate = fetchedData.filter { $0.value(forKey: "movieCode") as? String == movie.movieCode }

            if objectUpdate.isEmpty {
                _ = self.saveMovie(movie: movie)
                
                let fetchedData = try context.fetch(fetchRequest)
                let objectUpdate = fetchedData.filter { $0.value(forKey: "movieCode") as? String == movie.movieCode }
                switch type {
                case .like:
                    let likeBoolean = objectUpdate[0].value(forKey: "likeBoolean") as! Bool
                    objectUpdate[0].setValue(likeBoolean.toggle(), forKey: "likeBoolean")
                    
                case .watchLater:
                    let watchLaterBoolean = objectUpdate[0].value(forKey: "watchLaterBoolean") as! Bool
                    objectUpdate[0].setValue(watchLaterBoolean.toggle(), forKey: "watchLaterBoolean")
                }
            } else {
                switch type {
                case .like:
                    let likeBoolean = objectUpdate[0].value(forKey: "likeBoolean") as! Bool
                    objectUpdate[0].setValue(likeBoolean.toggle(), forKey: "likeBoolean")
                    
                case .watchLater:
                    let watchLaterBoolean = objectUpdate[0].value(forKey: "watchLaterBoolean") as! Bool
                    objectUpdate[0].setValue(watchLaterBoolean.toggle(), forKey: "watchLaterBoolean")
                }
            }
            
            do {
                try context.save()
                return Observable.just(true)
            } catch {
                return Observable.just(false)
            }
            
        } catch let err as NSError {
            fatalError("Unresolved error \(err), \(err.userInfo)")
        }
    }
    
    
    
    
    //MARK: RankList
    func fetchLocalRankList(listType: BoxOfficeType, onComplete: @escaping (Result<NSManagedObject?,Error>) -> Void) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: rankListName)
        
        do {
            let fetchedData = try context.fetch(fetchRequest)
            
            if fetchedData.isEmpty {
                onComplete(.failure(NSError(domain: "저장된 콘텐츠가 없습니다.", code: -1)))
            } else {
                let filterdData = fetchedData.filter { $0.value(forKey: "type") as! String == listType.rawValue }
                
                if filterdData.isEmpty {
                    onComplete(.failure(NSError(domain: "저장된 콘텐츠가 없습니다.", code: -1)))
                } else {
                    onComplete(.success(filterdData[0]))
                }
            }
        } catch {
            onComplete(.failure(NSError(domain: "저장된 콘텐츠가 없습니다.", code: -1)))
            return
        }
    }
    
    
    
    func coverUpRankList(data: ViewRankList) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        deleteRankList(type: data.boxOfficeType)
        
        let rankListObject = NSEntityDescription.insertNewObject(forEntityName: rankListName, into: context) as! RankList
        rankListObject.setValue(data.boxOfficeType.rawValue, forKey: "type")
        rankListObject.setValue(data.showRange, forKey: "showRange")

        let rankItems = data.viewMovieList
        
        for item in rankItems {
            let itemObject = NSEntityDescription.insertNewObject(forEntityName: rankItemsName, into: context) as! RankItems
            itemObject.setValues(viewMovieItems: item)
            rankListObject.addToRankItems(itemObject)
        }
        
        do {
            try context.save()
        } catch {
            context.rollback()
        }
    }
    
    func deleteRankList(type: BoxOfficeType) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: rankListName)
        
        do {
            let fetchedData = try context.fetch(fetchRequest)
            
            let deleteObject = fetchedData.filter { $0.value(forKey: "type") as! String == type.rawValue }
                        
            if deleteObject.isEmpty == false {
                context.delete(deleteObject[0])
            } else {
                return
            }
            do {
                try context.save()
            } catch let err as NSError {
                fatalError("Unresolved error \(err), \(err.userInfo)")
            }
        } catch let err as NSError {
            fatalError("Unresolved error \(err), \(err.userInfo)")
        }
    }
    
    //MARK: Send Fetched Results Rx Observable
    func fetchLocalListRX() -> Observable<[NSManagedObject?]> {
        return Observable.create ({ emitter in
            self.fetchLocalList() { result in
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
    
    func fetchLocalRankListRX(listType: BoxOfficeType) -> Observable<NSManagedObject?> {
        return Observable.create({ emitter in
            self.fetchLocalRankList(listType: listType) { result in
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
}






extension NSManagedObject {
    
    func setValues(viewMovieItems: ViewMovieItems) {
        self.setValue(viewMovieItems.watchLaterBoolean, forKey: "watchLaterBoolean")
        self.setValue(viewMovieItems.likeBoolean, forKey: "likeBoolean")
        self.setValue(viewMovieItems.title, forKey: "title")
        self.setValue(viewMovieItems.runtime, forKey: "runtime")
        self.setValue(viewMovieItems.repRlsDate, forKey: "repRlsDate")
        self.setValue(viewMovieItems.rating, forKey: "rating")
        self.setValue(viewMovieItems.rankOldAndNew, forKey: "rankOldAndNew")
        self.setValue(viewMovieItems.rankInten, forKey: "rankInten")
        self.setValue(viewMovieItems.rank, forKey: "rank")
        self.setValue(viewMovieItems.posterURLs, forKey: "posterURLs")
        self.setValue(viewMovieItems.plot, forKey: "plot")
        self.setValue(viewMovieItems.movieId, forKey: "movieId")
        self.setValue(viewMovieItems.likeBoolean, forKey: "likeBoolean")
        self.setValue(viewMovieItems.genre, forKey: "genre")
        self.setValue(viewMovieItems.directorNm, forKey: "directorNm")
        self.setValue(viewMovieItems.company, forKey: "company")
        self.setValue(viewMovieItems.baseDate, forKey: "baseDate")
        self.setValue(viewMovieItems.audiAcc, forKey: "audiAcc")
        self.setValue(viewMovieItems.actors, forKey: "actors")
        self.setValue(viewMovieItems.movieCode, forKey: "movieCode")
    }
}


