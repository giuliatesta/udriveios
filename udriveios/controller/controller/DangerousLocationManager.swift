import Foundation
import CoreLocation

/* Class used to manage the storage of CoreData's DangerousLocation instances */
class DangerousLocationManager : NSObject, CLLocationManagerDelegate {
    var dangerousLocationManager = CLLocationManager()
    var coreDataManager : CoreDataManager;
    
    private var _locations : [CLLocation] = [];
    
    var authorizationGranted : Bool = true;
    
    static private var instance : DangerousLocationManager = DangerousLocationManager();
    
    private override init() {
        coreDataManager = CoreDataManager.getInstance();
        super.init()
        dangerousLocationManager.delegate = self     // must be done AFTER calling super
        authorizationGranted = dangerousLocationManager.authorizationStatus == .authorizedWhenInUse || dangerousLocationManager.authorizationStatus == .authorizedAlways
    }
    
    static func getInstance() -> DangerousLocationManager {
        return instance;
    }
    
    func startRecordingDangerousLocations() {
        dangerousLocationManager.startUpdatingLocation();
    }
    
    func stopRecordingDangerousLocations(direction: Direction, duration: Int) {
        coreDataManager.saveEntityDangerousLocation(locations: _locations, direction: direction, duration: duration)
        dangerousLocationManager.stopUpdatingLocation();
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        _locations.insert(contentsOf: locations, at: locations.endIndex - 1)
    }
}
