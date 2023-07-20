//
//  LocationManager.swift
//  udriveios
//
//  Created by Giulia Testa on 20/07/23.
//

import Foundation
import CoreLocation
import SwiftUI

class LocationManager: NSObject, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    @Binding var authorizationDenied : Bool;
    @Binding var authorizationGranted : Bool;

    init(authorizationDenied : Binding<Bool>, authorizationGranted : Binding<Bool>) {
        _authorizationDenied = authorizationDenied          // must be done BEFORE calling super
        _authorizationGranted = authorizationGranted
        super.init()
        locationManager.delegate = self     // must be done AFTER calling super
        
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
}
