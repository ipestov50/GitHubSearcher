//
//  CoreDataManager.swift
//  GitHubSearcher
//
//  Created by Ivan Pestov on 01.12.2022.
//

import Foundation
import CoreData

class CoreDataManager {
    static let instance = CoreDataManager()
    
    private init() {}
    
    // Создание контекста
    lazy var context: NSManagedObjectContext = {
        persistentContainer.viewContext
    }()
    
    // Описание сущности
    func entityForName(entityName: String) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: entityName, in: context)!
    }
    
    // MARK: - Core Data stack 
    
    lazy var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "Model")
            container.loadPersistentStores { description, error in
                if let error = error {
                    fatalError("Unable to load persistent stores: \(error)")
                }
            }
            return container
        }()
    
    lazy var managedContext: NSManagedObjectContext = self.persistentContainer.viewContext
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
