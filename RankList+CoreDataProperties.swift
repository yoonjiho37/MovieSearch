//
//  RankList+CoreDataProperties.swift
//  
//
//  Created by 윤지호 on 2023/06/02.
//
//

import Foundation
import CoreData


extension RankList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RankList> {
        return NSFetchRequest<RankList>(entityName: "RankList")
    }

    @NSManaged public var showRange: String?
    @NSManaged public var type: String?
    @NSManaged public var rankItems: Set<RankItems>

}

// MARK: Generated accessors for rankItems
extension RankList {

    @objc(addRankItemsObject:)
    @NSManaged public func addToRankItems(_ value: RankItems)

    @objc(removeRankItemsObject:)
    @NSManaged public func removeFromRankItems(_ value: RankItems)

    @objc(addRankItems:)
    @NSManaged public func addToRankItems(_ values: NSSet)

    @objc(removeRankItems:)
    @NSManaged public func removeFromRankItems(_ values: NSSet)

}
