//
//  RankItems+CoreDataProperties.swift
//  
//
//  Created by 윤지호 on 2023/06/02.
//
//

import Foundation
import CoreData


extension RankItems {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RankItems> {
        return NSFetchRequest<RankItems>(entityName: "RankItems")
    }

    @NSManaged public var actors: [String]?
    @NSManaged public var audiAcc: String?
    @NSManaged public var baseDate: String?
    @NSManaged public var company: String?
    @NSManaged public var directorNm: String?
    @NSManaged public var genre: String?
    @NSManaged public var likeBoolean: Bool
    @NSManaged public var movieCode: String?
    @NSManaged public var movieId: String?
    @NSManaged public var plot: String?
    @NSManaged public var posterURLs: [String]?
    @NSManaged public var rank: Int16
    @NSManaged public var rankInten: String?
    @NSManaged public var rankOldAndNew: String?
    @NSManaged public var rating: String?
    @NSManaged public var repRlsDate: String?
    @NSManaged public var runtime: String?
    @NSManaged public var title: String?
    @NSManaged public var watchLaterBoolean: Bool
    @NSManaged public var rankList: RankList?

}
