//
//  VoteModel+CoreDataProperties.swift
//  TheCatApp
//
//  Created by Federico Torres on 14/05/22.
//
//

import Foundation
import CoreData


extension VoteModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VoteModel> {
        return NSFetchRequest<VoteModel>(entityName: "VoteModel")
    }

    @NSManaged public var name: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var voteType: Bool

}

extension VoteModel : Identifiable {

}
