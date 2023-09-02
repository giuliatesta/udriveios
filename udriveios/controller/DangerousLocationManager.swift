import Foundation
import CoreLocation

class DangerousLocationManager : NSObject, CLLocationManagerDelegate {
    var dangerousLocationManager = CLLocationManager()
    var coreDataManager : CoreDataManager;
    var authorizationGranted : Bool = true;
    
    private var _locations : [CLLocation] = [];

    private override init() {
        coreDataManager = CoreDataManager.getInstance();
        super.init()
        dangerousLocationManager.delegate = self     // must be done AFTER calling supe
        authorizationGranted = dangerousLocationManager.authorizationStatus == .authorizedWhenInUse || dangerousLocationManager.authorizationStatus == .authorizedAlways
    }

    
    static private var instance : DangerousLocationManager = DangerousLocationManager();
    
    static func getInstance() -> DangerousLocationManager {
        return instance;
    }
    
    func startRecordingDangerousLocations() {
        dangerousLocationManager.startUpdatingLocation();
    }
    
    func stopRecordingDangerousLocations(direction: Direction, duration: Int) {
        print(duration)
        print(direction)
        coreDataManager.saveEntityDangerousLocation(locations: _locations, direction: direction, duration: duration)
        dangerousLocationManager.stopUpdatingLocation();
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        _locations.insert(contentsOf: locations, at: locations.endIndex - 1)
    }
}
