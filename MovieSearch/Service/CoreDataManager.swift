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
    
    let itemModelName: String = "MovieItems"
    
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
            
        } catch let err as NSError {
            onComplete(.failure(err))
        }
    }
    
    
    func saveMovie(movie: ViewMovieItems) {
        print("save => start")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        guard let itemEntity = NSEntityDescription.entity(forEntityName: itemModelName, in: context) else { return }

        let listobject = NSManagedObject(entity: itemEntity, insertInto: context)
        listobject.setvalues(viewMovieItems: movie)
        
        do {
            try context.save()
        } catch let err as NSError {
            fatalError("Unresolved error \(err), \(err.userInfo)")
        }
        
    }
    
    func deleteMovie(code: String, onCpmpleted: @escaping (Bool) -> ()) {
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
            
        } catch let err as NSError {
            fatalError("Unresolved error \(err), \(err.userInfo)")
        }
        
    }
    
    
    func updateData(type: UpdateType,movie: ViewMovieItems) -> Observable<Bool> {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: itemModelName)
        
        do {
            let fetchedData = try context.fetch(fetchRequest)

            let objectUpdate = fetchedData.filter { $0.value(forKey: "movieCode") as? String == movie.movieCode }

            if objectUpdate.isEmpty {
                self.saveMovie(movie: movie)
                
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
    
    
    //MARK: Send Fetched Results Rx
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
    
    
}

extension NSManagedObject {
    func setvalues(viewMovieItems: ViewMovieItems) {
        self.setValue(viewMovieItems.watchLaterBoolean, forKey: "watchLaterBoolean")
        self.setValue(viewMovieItems.likeBoolean, forKey: "likeBoolean")
        self.setValue(viewMovieItems.title, forKey: "title")
        self.setValue(viewMovieItems.runtime, forKey: "runtime")
        self.setValue(viewMovieItems.repRlsDate, forKey: "repRlsDate")
        self.setValue(viewMovieItems.rating, forKey: "rating")
        self.setValue(viewMovieItems.rankOldAndNew, forKey: "rankOldAndNew")
        self.setValue(viewMovieItems.rankInten, forKey: "rankInten")
        self.setValue(viewMovieItems.rank, forKey: "rank")
        self.setValue(viewMovieItems.posterURL, forKey: "posterURLs")
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


