//
//  DbManager.swift
//  udriveios
//
//  Created by Giulia Testa on 24/08/23.
//

import Foundation
import CoreData
import CoreLocation


class CoreDataManager : ObservableObject {
    static private let instance = CoreDataManager()
    private init() {}
    
    static func getInstance() -> CoreDataManager {
        return instance
    }
    
    var persistentContainer = NSPersistentContainer(name: "udriveDataModel")
    
    func initManager() {
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        get {
            return persistentContainer.viewContext
        }
        set {
            self.context = newValue
        }
    }
    
    func saveContext() {
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    print("Error saving context: \(error)")
                }
            }
        }

    
    func saveLocations(locations: [CLLocation]) {
        for location in locations {
            let newLocationEntity = Location(entity: NSEntityDescription.entity(forEntityName: "Location", in: context) ?? NSEntityDescription(), insertInto: context)
        
            newLocationEntity.latitude = location.coordinate.latitude
            newLocationEntity.longitude = location.coordinate.longitude
            newLocationEntity.timestamp = location.timestamp
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
}
