import Foundation
import CoreLocation
import SwiftUI

/* Class used to manage the storage of CoreData's Location instances and the location
 authorization request to the user */
class LocationManager: NSObject, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    var coreDataManager : CoreDataManager;
    @Binding var authorizationDenied : Bool;
    @Binding var authorizationGranted : Bool;

    private init(authorizationDenied : Binding<Bool>, authorizationGranted : Binding<Bool>) {
        _authorizationDenied = authorizationDenied          // must be done BEFORE calling super
        _authorizationGranted = authorizationGranted
        coreDataManager = CoreDataManager.getInstance();
        super.init()
        locationManager.delegate = self     // must be done AFTER calling super
    }
    
    static private var instance : LocationManager?;
    
    static func getInstance(authorizationDenied : Binding<Bool>, authorizationGranted : Binding<Bool>) -> LocationManager {
        if(instance == nil) {
            instance = LocationManager(authorizationDenied: authorizationDenied, authorizationGranted: authorizationGranted);
        }
        return instance!;
    }
    
    static func getInstance() -> LocationManager {
        return instance!; 
    }
    

    func requestLocationAuthorization() {
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            handleAuthorizationStatus(locationManager.authorizationStatus)
        }
    }

    func handleAuthorizationStatus(_ status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            authorizationGranted = true
            break
        case .denied, .restricted:
            authorizationDenied = true;
            break
        default:
            break
        }
    }
   
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        handleAuthorizationStatus(locationManager.authorizationStatus)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleAuthorizationStatus(status)
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
