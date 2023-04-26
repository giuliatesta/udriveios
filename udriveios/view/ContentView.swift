//
//  ContentView.swift
//  udriveios
//
//  Created by Giulia Testa on 26/04/23.
//

import SwiftUI

func signin() {
    print("ciao")
}
struct ContentView: View {
    var body: some View {
        VStack {
            Image("steering_wheel")
            Text("uDrive").foregroundColor(Color.pink)
        }
        
        .padding()
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
    }
}
