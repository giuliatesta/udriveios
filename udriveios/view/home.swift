//
//  File.swift
//  udriveios
//
//  Created by Giulia Testa on 26/04/23.
//

import Foundation
import SwiftUI
 
struct HomePage: View {
    @State private var showingAlert = false
    @State private var accelerometerValues = AccelerometerValues()
    @State private var riskyBehaviour = true
    
    var body: some View {
        NavigationView {
            VStack{
                VStack{
                    Image(systemName: "arrow.up")
                        .fillImageModifier()
                        .padding([.horizontal], 150)
                    HStack{
                        Image(systemName: "arrow.left")
                            .fillImageModifier()
                        Image(systemName: "triangle")
                            .fillImageModifier()
                        Image(systemName: "arrow.right")
                            .fillImageModifier()
                    }.padding(20)
                    Image(systemName: "arrow.down")
                        .fillImageModifier()
                        .padding([.horizontal], 150)
                }.padding(100)
                
                Text(self.accelerometerValues.getValuesToString())
                .navigationTitle("uDrive")
                //.toolbar(.visible)
                Button(action: {
                    self.showingAlert = true
                }) {
                    Text("Button")
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Titolo"), message: Text("Testo"), dismissButton: .default(Text("OK!")))
                }
            }.alert(isPresented: $riskyBehaviour) {
                Alert(title: Text("Attenzione, pericolo"))
            }
        }.viewDidLoadModifier{
            //When the view is loaded, start to get accelerometer values
            self.accelerometerValues.startAccelerometers()
        }
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
