import Foundation
import CoreData
import CoreLocation

/* Class used to correctly deal with instances created in the udriveDataModel */
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
    
    func saveEntityLocations(locations: [CLLocation]) {
        for location in locations {
            createLocationEntity(location: location)
            saveContext()
        }
        print("Saved following locations: \(locations)");
    }
    
    func createLocationEntity(location : CLLocation) -> Location {
        let newLocationEntity = Location(entity: NSEntityDescription.entity(forEntityName: "Location", in: _context) ?? NSEntityDescription(), insertInto: _context)
        newLocationEntity.latitude = location.coordinate.latitude
        newLocationEntity.longitude = location.coordinate.longitude
        newLocationEntity.timestamp = location.timestamp
        return newLocationEntity;
    }
    
    func saveEntityDangerousLocation(locations: [CLLocation], direction: Direction, duration: Int) {
        let locationEntities : [Location] = locations.map { location in
            createLocationEntity(location: location)
        }
        
        let newDangerousLocationEntity = DangerousLocation(entity: NSEntityDescription.entity(forEntityName: "DangerousLocation", in: _context) ?? NSEntityDescription(), insertInto: _context)
        newDangerousLocationEntity.locations = NSSet(array: locationEntities)
        newDangerousLocationEntity.direction = Int64(direction.getInt()) //check int or string
        newDangerousLocationEntity.duration = Int64(duration)
        saveContext()
        print("Saved following dangerous location: \(newDangerousLocationEntity)");
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
            print("Cannot delete data in \(entityName) error :", error)
        }
    }
    
}
