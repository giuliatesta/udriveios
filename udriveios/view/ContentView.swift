//
//  ContentView.swift
//  udriveios
//
//  Created by Giulia Testa on 26/04/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HomePage()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    
        ContentView()
            .preferredColorScheme(.light)
        
        
    }
}
