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
            createEntityLocation(location: location)
            saveContext()
        }
        // print("Saved following locations: \(locations)");
    }
    
    func createEntityLocation(location : CLLocation) -> Location {
        let newLocationEntity = Location(entity: NSEntityDescription.entity(forEntityName: "Location", in: _context) ?? NSEntityDescription(), insertInto: _context)
        newLocationEntity.latitude = location.coordinate.latitude
        newLocationEntity.longitude = location.coordinate.longitude
        newLocationEntity.timestamp = location.timestamp
        return newLocationEntity;
    }
    
    func saveEntityElapsedTime(duration: Int, isDangerous: Bool) {
        let newElapsedTimeEntity = ElapsedTime(entity: NSEntityDescription.entity(forEntityName: "ElapsedTime", in: _context) ?? NSEntityDescription(), insertInto: _context)
        newElapsedTimeEntity.seconds = Int64(duration)
        newElapsedTimeEntity.isDangerous = isDangerous
        saveContext()
        print("Saved following time interval: \(newElapsedTimeEntity)");
    }
    
    func saveEntityDangerousLocation(locations: [CLLocation], direction: Direction, duration: Int) {
        let locationEntities : [Location] = locations.map { location in
            createEntityLocation(location: location)
        }
        let newDangerousLocationEntity = DangerousLocation(entity: NSEntityDescription.entity(forEntityName: "DangerousLocation", in: _context) ?? NSEntityDescription(), insertInto: _context)
        newDangerousLocationEntity.locations = NSSet(array: locationEntities)
        newDangerousLocationEntity.direction = Int64(direction.getInt()) //check int or string
        newDangerousLocationEntity.duration = Int64(duration)
        saveContext()
        // print("Saved following dangerous location: \(newDangerousLocationEntity)");
    }
    
    func saveEntityBestScore(totalSafeTime: Int, totalDangerousTime: Int ){
        let newBestScoreEntity = BestScore(entity: NSEntityDescription.entity(forEntityName: "BestScore", in: _context) ?? NSEntityDescription(), insertInto: _context)
        newBestScoreEntity.totalSafeTime = Int64(totalSafeTime) //check int or string
        newBestScoreEntity.totalDangerousTime = Int64(totalDangerousTime) //check int or string
        saveContext()
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
    
    func getAll(entityName: String) -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            var objects : [NSManagedObject] = []
            let results = try _context.fetch(fetchRequest)
            if(results.isEmpty){
                return []
            }
            for object in results {
            guard let objectData = object as? NSManagedObject else {continue}
                objects.append(objectData)
            }
            return objects
        } catch let error {
            print("Delete all data in \(entityName) error :", error)
        }
        return []
    }
    
}
