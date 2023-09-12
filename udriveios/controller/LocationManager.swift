import Foundation
import CoreLocation
import SwiftUI

/* Class used to manage the storage of CoreData's Location instances and the location
 authorization request to the user */
class LocationManager: NSObject, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    var coreDataManager : CoreDataManager;
    
    private override init() {
        coreDataManager = CoreDataManager.getInstance();
        super.init()
        locationManager.delegate = self     // must be done AFTER calling super
    }
    
    static private var instance : LocationManager = LocationManager();
    
    static func getInstance() -> LocationManager {
        return instance;
    }

    func requestLocationAuthorization() {
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func isAuthorizationGranted() -> Bool {
        return locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse
    }
   
    func startRecordingLocations() {
        locationManager.startUpdatingLocation();
    }
    
    func stopRecordingLocations() {
        locationManager.stopUpdatingLocation();
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        coreDataManager.saveEntityLocations(locations: locations)
    }
}
