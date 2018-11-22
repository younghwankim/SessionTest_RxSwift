//
//  CoreDataStack.swift
//  SessionTest
//
//  Created by Younghwan Kim on 2018-11-19.
//  Copyright © 2018 Younghwan Kim. All rights reserved.
//

import Foundation
import CoreData

open class CoreDataStack {
    
    let modelName: String
    
    public init(modelName: String) {
        self.modelName = modelName
    }
    
    public lazy var mainContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    public lazy var storeContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: self.modelName)
        
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                print("Could not fetch: \(error), \(error.userInfo)")
            }
        }
        print("debug_message: SQLITE FILE")
        print("debug_message: \(container.persistentStoreDescriptions[0].url!)")
        return container
    }()
    
    public func newDerivedContext() -> NSManagedObjectContext {
        let context = storeContainer.newBackgroundContext()
        return context
    }
    
    public func childContext() -> NSManagedObjectContext {
        let childContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        childContext.parent = mainContext
        
        return childContext
    }
    
    public func resetContext() {
        self.resetContext(context: self.mainContext)
    }
    
    public func resetContext(context: NSManagedObjectContext) {
        context.reset()
    }
    
    public func saveContext() {
        saveContext(mainContext)
    }
    
    public func saveContext(_ context: NSManagedObjectContext) {
        if context !== mainContext {
            saveDerivedContext(context)
            return
        }
        
        context.perform {
            do {
                try context.save()
            } catch let error as NSError {
                print("Could not fetch: \(error), \(error.userInfo)")
            }
        }
    }
    
    public func saveChildContext() {
        saveDerivedContext(childContext())
    }
    
    public func saveChildContextOnly() {
        let context = childContext()
        
        context.perform {
            do {
                try context.save()
            } catch let error as NSError {
                print("Could not fetch: \(error), \(error.userInfo)")
            }
        }
    }
    
    public func saveDerivedContext(_ context: NSManagedObjectContext) {
        context.perform {
            do {
                try context.save()
            } catch let error as NSError {
                print("Could not fetch: \(error), \(error.userInfo)")
            }
            
            self.saveContext(self.mainContext)
        }
    }
}
