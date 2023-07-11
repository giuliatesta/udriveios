//
//  StartView.swift
//  udriveios
//
//  Created by Sara Regali on 09/06/23.
//

import SwiftUI
import CoreLocation

func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) -> Bool {
    switch manager.authorizationStatus {
    case .authorizedWhenInUse:  // Location services are available.
        //enableLocationFeatures()
        break
    case .restricted, .denied:  // Location services currently unavailable.
        //disableLocationFeatures()
        break
    case .notDetermined:        // Authorization not determined yet.
        manager.requestWhenInUseAuthorization()
        break
    default:
        break
    }
    return manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways
}


struct StartView: View {
    @State private var showStopAlert = false;

    @State private var locationAuthorized : Bool = false;
    
    var body: some View {
        
        NavigationView{
            VStack{
                Text("Rotate your phone vertically").font(fontSystem)
                GifImage("rotate_phone").frame(width: 150, height: 150, alignment: .center)
                    Button(action: {
                        let locationManager = CLLocationManager();
                        locationAuthorized = locationManagerDidChangeAuthorization(locationManager)
                        print(locationAuthorized)
                    })
                    {
                        Text("Start Driving!")
                    }
                .padding()
                NavigationLink(destination: HomePage(),
                    isActive: $locationAuthorized
                ){
                    EmptyView()
                }
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
    
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
    
    
}
