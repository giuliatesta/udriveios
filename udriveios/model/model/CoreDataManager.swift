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
    private init() {
        self._context = persistentContainer.viewContext
    }
    
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
    
    var _context : NSManagedObjectContext;
    
    var context: NSManagedObjectContext {
        get {
            return persistentContainer.viewContext
        }
        set {
            self._context = newValue
        }
    }
    
    func saveContext() {
        if _context.hasChanges {
            do {
                try _context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }

    
    func saveLocations(locations: [CLLocation]) {
        for location in locations {
            let newLocationEntity = Location(entity: NSEntityDescription.entity(forEntityName: "Location", in: _context) ?? NSEntityDescription(), insertInto: _context)
        
            newLocationEntity.latitude = location.coordinate.latitude
            newLocationEntity.longitude = location.coordinate.longitude
            newLocationEntity.timestamp = location.timestamp
            saveContext()
        }
        print("Saved following locations: \(locations)");
    }
    
    func deleteEntity(entityName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false     // their property data resides in the row cache until the fault is fired - lazy
        do {
            let results = try _context.fetch(fetchRequest)
            for object in results {
            guard let objectData = object as? NSManagedObject else {continue}
                _context.delete(objectData)
            }
        } catch let error {
            print("Delete all data in \(entityName) error :", error)
        }
    }
    
}
