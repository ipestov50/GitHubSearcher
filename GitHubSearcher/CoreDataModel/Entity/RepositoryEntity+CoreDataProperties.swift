//
//  RepositoryEntity+CoreDataProperties.swift
//  GitHubSearcher
//
//  Created by Ivan Pestov on 01.12.2022.
//
//

import Foundation
import CoreData


extension RepositoryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RepositoryEntity> {
        return NSFetchRequest<RepositoryEntity>(entityName: "RepositoryEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var isSeen: Bool
    @NSManaged public var id: Int16

}

extension RepositoryEntity : Identifiable {

}
