//
//  CoreDataStack.swift
//  Reminder
//
//  Created by Aisultan Askarov on 1.11.2022.
//

import CoreData
import UIKit

class CoreDataStack {
    
    static let sharedManager = CoreDataStack()
    
    static let persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Reminder")
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        return container
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController<LocalNotifications> = {
        
        let fetchRequest: NSFetchRequest<LocalNotifications> = LocalNotifications.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateOfUpcomingNotification", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self as? NSFetchedResultsControllerDelegate

        return fetchedResultsController
        
    }()
    
    static var context: NSManagedObjectContext { return persistentContainer.viewContext }
    
    func loadUpcomingNotification() -> [LocalNotifications] {
        
        var _notifications : [LocalNotifications] = []
        let context = CoreDataStack.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<LocalNotifications> = LocalNotifications.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateOfUpcomingNotification", ascending: true)]
        
        do {
            let notifications = try context.fetch(fetchRequest)
            if(notifications.count > 0) {
                _notifications = notifications
            }
            
        } catch {
            print("Something happened while trying to retrieve tasks...")
        }
        
        return _notifications
    }
    
    class func deleteContext(entity: String) {
        
        let context = CoreDataStack.persistentContainer.viewContext
        
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            
            if let result = try context.fetch(request) as? [LocalNotifications] {
                for message in result {
                    context.delete(message)
                    try context.save()
                }
            }
            
        } catch {
            print("miss")
        }
        
    }
    
    class func saveContext () {
        
        let context = CoreDataStack.persistentContainer.viewContext
        
        guard context.hasChanges else {
            return
        }
        
        do {
            try context.save()
            try CoreDataStack().fetchedResultsController.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
    }
    
}
