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
    private var accelerometerValues = AccelerometerValues()
    
    var body: some View {
        NavigationView {
            VStack{
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
            }
        }.viewDidLoadModifier{
            self.accelerometerValues.startAccelerometers()
        }
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
