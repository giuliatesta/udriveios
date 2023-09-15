import Foundation
import CoreLocation
import SwiftUI

/* Class used to manage the storage of CoreData's Location instances and the location
 authorization request to the user */
class LocationManager: NSObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    private var coreDataManager : CoreDataManager;
    
    
    private override init() {
        coreDataManager = CoreDataManager.getInstance();
        super.init()
        locationManager.delegate = self     // must be done AFTER calling super
    }
    static private var instance : LocationManager?;
    
    static func getInstance() -> LocationManager {
        if(instance == nil) {
            instance = LocationManager();
        }
        return instance!;
    }
        
    var status : CLAuthorizationStatus {
        return locationManager.authorizationStatus
    }
    
    var authorized : Bool {
        return status == .authorizedAlways || status == .authorizedWhenInUse
    }

    func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
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
