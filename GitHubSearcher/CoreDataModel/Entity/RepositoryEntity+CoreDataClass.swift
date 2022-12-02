//
//  RepositoryEntity+CoreDataClass.swift
//  GitHubSearcher
//
//  Created by Ivan Pestov on 01.12.2022.
//
//

import Foundation
import CoreData

@objc(RepositoryEntity)
public class RepositoryEntity: NSManagedObject {
    convenience init() {
        self.init(entity: CoreDataManager.instance.entityForName(entityName: "RepositoryEntity"), insertInto: CoreDataManager.instance.context)
    }
}
