//
//  StartView.swift
//  udriveios
//
//  Created by Sara Regali on 09/06/23.
//

import SwiftUI

struct StartView: View {
    @State private var showStopAlert = false;
    @State var authorizationGranted: Bool = false;
    @State var authorizationDenied : Bool = false;

    @State var locationManager : LocationManager!;
    
    var body: some View {
        NavigationView{
            VStack{
                Text("Rotate your phone vertically").font(fontSystem)
                GifImage("rotate_phone").frame(width: 150, height: 150, alignment: .center)
                /*NavigationLink(destination: HomePage(), label: {
                    Text("Start Driving!").font(.largeTitle)
                })
                .padding()*/
                   Button(action: {
                       locationManager.requestLocationAuthorization()
                    })
                    {
                        Text("Start Driving!")
                    }
                    .padding()
                NavigationLink(destination: HomePage(), isActive: $authorizationGranted) {
                    EmptyView()
                }
            }
            .alert(isPresented: $authorizationDenied) {
                Alert(
                    title: Text("Location Access Denied"),
                    message: Text("To use this app, we need access to your location."),
                    primaryButton: .default(Text("Exit"), action: {
                        exit(0) // This will forcefully exit the app
                    }),
                    secondaryButton: .cancel()
                )
            }
            
        }
        .onAppear() {
            locationManager = LocationManager(authorizationDenied: $authorizationDenied, authorizationGranted: $authorizationGranted);
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    
    }
}

/*struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}*/
